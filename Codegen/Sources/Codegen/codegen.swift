import ArgumentParser
import Foundation

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
        var source = Source()

        source.add("import NAPIC")
        source.newline()
        source.add("""
            public typealias NewCallback = (napi_env, napi_value, [napi_value]) throws -> ValueConvertible

            private class NewCallbackData {
                let callback: NewCallback
                let argCount: Int

                init(callback: @escaping NewCallback, argCount: Int) {
                    self.callback = callback
                    self.argCount = argCount
                }
            }

            func newNAPICallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
                var this: napi_value!
                let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)
                napi_get_cb_info(env, cbinfo, nil, nil, &this, dataPointer)
                let data = Unmanaged<NewCallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

                let usedArgs: [napi_value]
                if data.argCount > 0 {
                    var args = [napi_value?](repeating: nil, count: data.argCount)
                    var argCount = data.argCount

                    args.withUnsafeMutableBufferPointer {
                        _ = napi_get_cb_info(env, cbinfo, &argCount, $0.baseAddress, nil, nil)
                    }

                    assert(argCount == data.argCount)
                    usedArgs = args.map { $0! }
                } else {
                    usedArgs = []
                }

                do {
                    return try data.callback(env, this, usedArgs).napiValue(env)
                } catch NAPI.Error.pendingException {
                    return nil
                } catch {
                    if try! exceptionIsPending(env) == false { try! throwError(env, error) }
                    return nil
                }
            }
            """)
        source.newline()

        for i in (0 ..< maxParams).reversed() {
            try generateClass(source: &source, paramCount: i)
        }

        return source
    }

    static func generateClass(source: inout Source, paramCount: Int) throws {
        let resultGeneric = "Result"
        let inGenerics = buildGenericParams(prefix: "P", count: paramCount)
        let allGenerics = [resultGeneric] + inGenerics
        let wheres = buildConformances(allGenerics, to: Types.valueConvertible)
        let commaSeparatedInGenerics = inGenerics.joined(separator: ", ")
        let inGenericsAsVals = inGenerics.map { $0.lowercased() }.joined(separator: ", ")

        let inGenericsAsArgs: String
        if paramCount > 0 {
            inGenericsAsArgs = ", " + inGenerics.map { "_ \($0.lowercased()): \($0)" }.joined(separator: ", ")
        } else {
            inGenericsAsArgs = ""
        }



        let inGenericsAsNAPI = inGenerics.map { "\($0.lowercased()).napiValue(env)" }.joined(separator: ", ")

        try source.declareClass(.public, "NewTypedFunction\(paramCount)", genericParams: allGenerics, conformsTo: Types.valueConvertible, wheres: wheres) { source in
            source.add("""
            public typealias ConvenienceCallback = (\(commaSeparatedInGenerics)) throws -> Result
            public typealias ConvenienceVoidCallback = (\(commaSeparatedInGenerics)) throws -> Void

            fileprivate enum InternalTypedFunction {
                case javascript(napi_value)
                case swift(String, NewCallback)
            }

            fileprivate let value: InternalTypedFunction

            public required init(_: napi_env, from: napi_value) throws {
                value = .javascript(from)
            }

            public init(named name: String, _ callback: @escaping NewCallback) {
                value = .swift(name, callback)
            }

            public func napiValue(_ env: napi_env) throws -> napi_value {
                switch value {
                case let .swift(name, callback):
                    return try Self.createFunction(env, named: name) { env, this, args in
                        try callback(env, this, args)
                    }
                case let .javascript(value):
                    return value
                }
            }

            public func call(_ env: napi_env, this: ValueConvertible = Undefined.default\(inGenericsAsArgs)) throws where Result == Undefined {
                let handle = try napiValue(env)

                let args: [napi_value?] = \(paramCount > 0 ? "try [\(inGenericsAsNAPI)]" : "[]")

                try args.withUnsafeBufferPointer { argsBytes in
                    try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
                }.throwIfError()
            }

            public func call(_ env: napi_env, this: ValueConvertible = Undefined.default\(inGenericsAsArgs)) throws -> Result {
                let handle = try napiValue(env)

                let args: [napi_value?] = \(paramCount > 0 ? "try [\(inGenericsAsNAPI)]" : "[]")

                var result: napi_value?
                try args.withUnsafeBufferPointer { argsBytes in
                    try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
                }.throwIfError()

                return try Result(env, from: result!)
            }

            private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping NewCallback) throws -> napi_value {
                var result: napi_value?
                let nameData = name.data(using: .utf8)!

                let data = NewCallbackData(callback: callback, argCount: \(paramCount))
                let unmanagedData = Unmanaged.passRetained(data)

                do {
                    try nameData.withUnsafeBytes {
                        napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback,  unmanagedData.toOpaque(), &result)
                    }.throwIfError()
                } catch {
                    unmanagedData.release()
                    throw error
                }

                return result!
            }
            """)
        }
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
        case .default:
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

extension Collection<Arg> {
    var value: String {
        if isEmpty {
            return ""
        } else {
            return map(\.value).joined(separator: ", ")
        }
    }
}

extension Collection<Where> {
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
