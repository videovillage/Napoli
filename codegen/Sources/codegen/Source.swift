import Foundation

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

    mutating func declareFunction(_ access: Access = .default, _ symbol: String, genericParams: [Generic], args: [Arg] = [], wheres: [Where] = [], builder: Builder) throws {
        try addSymbol(symbol)
        add("\(access.value.spaceIfNotEmpty())func \(symbol)\(genericParams.bracketedOrNone)(\(args.value))\(wheres.value.backspaceIfNotEmpty())")
        try buildClosure(builder)
    }

    @discardableResult
    mutating func declareClass(_ access: Access = .default, _ symbol: String, genericParams: [Generic], conformsTo: String = "", wheres: [Where] = [], docs: String? = nil, preamble: String? = nil, builder: Builder) throws -> Class {
        let c = Class(access: access, symbol: symbol, genericParams: genericParams, conformsTo: conformsTo, wheres: wheres, documentation: docs, preamble: preamble)
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
    let access: Access
    let symbol: String
    let genericParams: [Generic]
    let conformsTo: String
    let wheres: [Where]
    let documentation: String?
    let preamble: String?

    private var conformsString: String {
        if conformsTo.isEmpty {
            return ""
        } else {
            return ": \(conformsTo)"
        }
    }

    private var documentationJoined: String {
        guard let documentation, !documentation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return "" }

        return documentation.components(separatedBy: .newlines).map { "/// \($0)" }.joined(separator: "\n") + "\n"
    }

    private var preambleJoined: String {
        guard let preamble, !preamble.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return "" }

        return preamble + "\n"
    }

    var value: String {
        "\(documentationJoined)\(preambleJoined)\(access.value.spaceIfNotEmpty())class \(symbol)\(genericParams.bracketedOrNone)\(conformsString)\(wheres.value.backspaceIfNotEmpty())"
    }
}

struct Generic {
    let type: String
}

extension Collection<String> {
    var commaSeparated: String {
        joined(separator: ", ")
    }
}

extension Collection<Arg> {
    var value: String {
        if isEmpty {
            return ""
        } else {
            return map(\.value).commaSeparated
        }
    }
}

extension Collection<Where> {
    var value: String {
        if isEmpty {
            return ""
        } else {
            return "where \(map(\.value).commaSeparated)"
        }
    }
}

extension Collection<Generic> {
    func conforming(to type: String) -> [Where] {
        map { Where.conforms($0.type, type) }
    }

    func equals(_ type: String) -> [Where] {
        map { Where.equals($0.type, type) }
    }

    var bracketedOrNone: String {
        if isEmpty {
            return ""
        } else {
            return "<\(map(\.type).commaSeparated)>"
        }
    }
}

extension [Generic] {
    init(prefix: String, count: Int) {
        self = (0 ..< count).map { .init(type: "\(prefix)\($0)") }
    }
}

enum Where {
    case conforms(String, String)
    case equals(String, String)

    var value: String {
        switch self {
        case let .conforms(lhs, rhs):
            return "\(lhs): \(rhs)"
        case let .equals(lhs, rhs):
            return "\(lhs) == \(rhs)"
        }
    }
}

extension String {
    func prefixCommaIfNotEmpty() -> String {
        if !isEmpty {
            return ", " + self
        } else {
            return self
        }
    }

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
