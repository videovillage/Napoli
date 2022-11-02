import Foundation
import ArgumentParser

@main
struct Codegen: ParsableCommand {
    enum Error: LocalizedError {
        case invalidFolderURL

        var errorDescription: String? {
            switch self {
            case .invalidFolderURL:
                return "The specified path must be a valid directory."
            }
        }
    }

    @Argument(help: "The folder path to emit *.generated.swift files",
              transform: URL.init(fileURLWithPath:))
    var folderURL: URL

    func generatedFile(named name: String) -> URL {
        folderURL.appending(path: "\(name).generated.swift", directoryHint: .notDirectory)
    }

    func validate() throws {
        var isDirectory: ObjCBool = false
        let fileExists = FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDirectory)
        guard fileExists, isDirectory.boolValue else {
            throw Error.invalidFolderURL
        }
    }
    
    mutating func run() throws {
        try TypedFunction.generate(maxParams: 10).result().write(to: generatedFile(named: "TypedFunction"), atomically: true, encoding: .utf8)
    }
}

enum Types {
    static let valueConvertible = "ValueConvertible"
}

enum TypedFunction {
    static func generate(maxParams: Int) throws -> Source {
        let resultGeneric = "Result"
        let inGenerics = buildGenericParams(prefix: "P", count: maxParams)
        let allGenerics = [resultGeneric] + inGenerics

        let wheres = buildConformances(allGenerics, to: Types.valueConvertible)

        var source = Source()

        source.add("import NAPIC")
        source.newline()

        try source.declareClass(.public, "TypedFunction", genericParams: allGenerics, conformsTo: Types.valueConvertible, wheres: wheres) { source in
            source.add("""
                       fileprivate enum InternalTypedFunction {
                           case javascript(napi_value)
                           case swift(String, TypedClosure)
                       }

                       public typealias TypedArgs = (\(inGenerics.joined(separator: ", ")))
                       public typealias TypedClosure = (napi_env, TypedArgs) throws -> Result
                       fileprivate let value: InternalTypedFunction

                       public required init(_: napi_env, from: napi_value) throws {
                           value = .javascript(from)
                       }

                       fileprivate init(named name: String, _ callback: @escaping TypedClosure) {
                           value = .swift(name, callback)
                       }

                       public func napiValue(_ env: napi_env) throws -> napi_value {
                           switch value {
                           case let .swift(name, callback):
                               return try createFunction(env, named: name) { env, args in
                                   try callback(env, Self.resolveArgs(env, args: args))
                               }
                           case let .javascript(value):
                               return value
                           }
                       }

                       public static func resolveArgs(_ env: napi_env, args: Arguments) throws -> TypedArgs {
                           try (\(inGenerics.enumerated().map { "\($0.element)(env, from: args.\($0.offset))" }.joined(separator: ", ")))
                       }

                       fileprivate func _call(_ env: napi_env, this: ValueConvertible, args: [ValueConvertible]) throws where Result == Undefined {
                           let handle = try napiValue(env)

                           let args: [napi_value?] = try args.map { try $0.napiValue(env) }

                           try args.withUnsafeBufferPointer { argsBytes in
                               try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
                           }.throwIfError()
                       }

                       fileprivate func _call(_ env: napi_env, this: ValueConvertible, args: [ValueConvertible]) throws -> Result {
                           let handle = try napiValue(env)

                           let args: [napi_value?] = try args.map { try $0.napiValue(env) }

                           var result: napi_value?
                           try args.withUnsafeBufferPointer { argsBytes in
                               try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
                           }.throwIfError()

                           return try Result(env, from: result!)
                       }
                       """)
        }

        return source
    }
}

struct Source {
    enum Error: LocalizedError {
        case symbolDefinedInScope(String)

        var errorDescription: String? {
            switch self {
            case let .symbolDefinedInScope(symbol):
                return "\"\(symbol)\" already defined"
            }
        }
    }

    typealias Builder = (inout Source) throws -> Void
    static let indent = "    "
    private var indentLevel: Int = 0
    private var scopedSymbols: Set<String> = []
    private(set) var lines: [String] = []

    private init(indentLevel: Int, scopedSymbols: Set<String>) {
        self.indentLevel = indentLevel
        self.scopedSymbols = scopedSymbols
    }

    init() {}

    mutating func declareFunction(_ access: Access = .default, _ symbol: String, genericParams: [String], args: [Arg] = [], wheres: [Where] = [], builder: Builder) throws {
        try addSymbol(symbol)
        add("\(access.value.spaceIfNotEmpty())func \(symbol)\(genericParamsValue(genericParams))(\(args.value))\(wheres.value.backspaceIfNotEmpty())")
        try buildClosure(builder)
    }

    @discardableResult
    mutating func declareClass(_ access: Access = .default, _ symbol: String, genericParams: [String], conformsTo: String = "", wheres: [Where] = [], builder: Builder) throws -> Class {
        let c = Class(access: access, symbol: symbol, genericParams: genericParams, conformsTo: conformsTo, wheres: wheres)
        try declareClass(c, builder: builder)
        return c
    }

    mutating func declareClass(_ c: Class, builder: Builder) throws {
        try addSymbol(c.symbol)
        add(c.value)
        try buildClosure(builder)
    }

    mutating func buildClosure(_ builder: Builder) throws {
        addToLast(" {")
        var new = Source(indentLevel: indentLevel + 1, scopedSymbols: scopedSymbols)
        try builder(&new)

        if new.lines.isEmpty {
            addToLast("}")
        } else {
            lines.append(contentsOf: new.lines)
            add("}")
        }

        newline()
    }

    mutating func newLineIfNotEmpty() {
        if !(lines.last?.isEmpty ?? true) {
            newline()
        }
    }

    mutating func newline(_ count: Int = 1) {
        for _ in 0 ..< count {
            lines.append("")
        }
    }

    mutating func add(_ add: String) {
        let indent = [String](repeating: Self.indent, count: indentLevel).joined()
        lines.append(contentsOf: add.components(separatedBy: .newlines).map { "\(indent)\($0)" })
    }

    mutating func addToLast(_ add: String) {
        lines[lines.endIndex - 1].append(add)
    }

    private mutating func addSymbol(_ symbol: String) throws {
        guard !scopedSymbols.contains(symbol) else {
            throw Error.symbolDefinedInScope(symbol)
        }

        scopedSymbols.insert(symbol)
    }

    public func result() -> String {
        lines.joined(separator: "\n")
    }
}

enum Access {
    case `public`, `private`, `fileprivate`, `default`

    var value: String {
        switch self {
        case .public:
            return "public"
        case .private:
            return "private"
        case .fileprivate:
            return "fileprivate"
        case .`default`:
            return ""
        }
    }
}

struct Arg {
    let externalSymbol: String?
    let internalSymbol: String
    let type: String

    var value: String {
        let internalBase = "\(internalSymbol): \(type)"
        if let externalSymbol {
            return "\(externalSymbol) \(internalBase)"
        } else {
            return internalBase
        }
    }

    static func named(_ symbol: String, _ type: String) -> Self {
        self.init(externalSymbol: nil, internalSymbol: symbol, type: type)
    }

    static func unnamed(_ symbol: String, _ type: String) -> Self {
        self.init(externalSymbol: "_", internalSymbol: symbol, type: type)
    }
}

struct Class {
    var access: Access
    var symbol: String
    var genericParams: [String]
    var conformsTo: String
    var wheres: [Where]

    private var conformsString: String {
        if conformsTo.isEmpty {
            return ""
        } else {
            return ": \(conformsTo)"
        }
    }

    var value: String {
        "\(access.value.spaceIfNotEmpty())class \(symbol)\(genericParamsValue(genericParams))\(conformsString)\(wheres.value.backspaceIfNotEmpty())"
    }
}

extension Collection where Element == Arg {
    var value: String {
        if isEmpty {
            return ""
        } else {
            return map(\.value).joined(separator: ", ")
        }
    }
}

extension Collection where Element == Where {
    var value: String {
        if isEmpty {
            return ""
        } else {
            return "where \(map(\.value).joined(separator: ", "))"
        }
    }
}

enum Where {
    case conforms(String, String)

    var value: String {
        switch self {
        case let .conforms(lhs, rhs):
            return "\(lhs): \(rhs)"
        }
    }
}

extension String {
    func spaceIfNotEmpty() -> String {
        if !isEmpty {
            return self + " "
        } else {
            return self
        }
    }

    func backspaceIfNotEmpty() -> String {
        if !isEmpty {
            return " " + self
        } else {
            return self
        }
    }

    func spaceEachSideIfNotEmpty() -> String {
        if !isEmpty {
            return " \(self) "
        } else {
            return self
        }
    }
}

func buildGenericParams(prefix: String, count: Int) -> [String] {
    (0 ..< count).map { "\(prefix)\($0)" }
}

func genericParamsValue(_ params: [String]) -> String {
    if params.isEmpty {
        return ""
    } else {
        return "<\(params.joined(separator: ", "))>"
    }
}

func buildConformances(_ symbols: [String], to conform: String) -> [Where] {
    symbols.map { Where.conforms($0, conform) }
}
