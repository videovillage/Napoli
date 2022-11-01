import NAPIC

public enum AnyValue: ValueConvertible {
    case `class`(Class)
    case function(Function)
    case object([String: AnyValue])
    case array([AnyValue])
    case string(String)
    case number(Double)
    case boolean(Bool)
    case null
    case undefined

    public init(_: napi_env, from _: napi_value) throws {
        fatalError("Not implemented")
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch self {
        case let .class(`class`): return try `class`.napiValue(env)
        case let .function(function): return try function.napiValue(env)
        case let .object(object): return try object.napiValue(env)
        case let .array(array): return try array.napiValue(env)
        case let .string(string): return try string.napiValue(env)
        case let .number(number): return try number.napiValue(env)
        case let .boolean(boolean): return try boolean.napiValue(env)
        case .null: return try Null.default.napiValue(env)
        case .undefined: return try Undefined.default.napiValue(env)
        }
    }
}

extension AnyValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let object = try? container.decode([String: AnyValue].self) {
            self = .object(object)
        } else if let array = try? container.decode([AnyValue].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if let boolean = try? container.decode(Bool.self) {
            self = .boolean(boolean)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Failed to decode value"))
        }
    }
}

extension AnyValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .class: return "[Function: ...]"
        case .function: return "[Function: ...]"
        case let .object(object): return "{ \(object.map { "\($0): \($1)" }.joined(separator: ", "))) }"
        case let .array(array): return "[ \(array.map { String(describing: $0) }.joined(separator: ", ")) ]"
        case let .string(string): return string
        case let .number(number): return String(describing: number)
        case let .boolean(boolean): return boolean ? "true" : "false"
        case .null: return "null"
        case .undefined: return "undefined"
        }
    }
}
