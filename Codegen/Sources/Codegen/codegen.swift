import Foundation

@main
public enum Codegen {
    public static func main() {
        do {
            print(try TypedFunction.generate(maxParams: 10).result())
        } catch {
            print("An error occured: \(error.localizedDescription)")
        }
    }
}

enum TypedFunction {
    static func generate(maxParams: Int) throws -> Source {
        let resultGeneric = "Result"
        let inGenerics = buildGenericParams(prefix: "P", count: maxParams)
        let allGenerics = [resultGeneric] + inGenerics

        var source = Source()

        try source.declareFunction(.public, "testFunction", genericParams: allGenerics, args: [.named("test", "Int")]) { source in

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

        add("\(access.value.spaceIfNotEmpty())func \(symbol)(\(args.value))\(wheres.value)")
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
}

func buildGenericParams(prefix: String, count: Int) -> [String] {
    (0 ..< count).map { "\(prefix)\($0)" }
}

func buildConformances(_ symbols: [String], to conform: String) -> [Where] {
    symbols.map { Where.conforms($0, conform) }
}
