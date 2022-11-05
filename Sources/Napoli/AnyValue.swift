import Foundation
import NAPIC

/// Type-erased `ValueConvertible` for types that conform to `Codable`
public enum AnyValue: ValueConvertible, Codable {
    case object([String: AnyValue])
    case array([AnyValue])
    case string(String)
    case number(Double)
    case boolean(Bool)
    case date(Date)
    case null
    case undefined

    enum Error: LocalizedError {
        case unknownType(UInt32)

        var errorDescription: String? {
            switch self {
            case let .unknownType(value):
                return "Initializing from unknown type (\(value)) is not supported."
            }
        }
    }

    public init(_ env: napi_env, from value: napi_value) throws {
        var type: napi_valuetype = napi_undefined
        try napi_typeof(env, value, &type).throwIfError()
        switch type {
        case napi_boolean:
            self = try .boolean(Bool(env, from: value))
        case napi_object:
            switch try ObjectType(env, object: value) {
            case .array:
                self = try .array([AnyValue](env, from: value))
            case .date:
                self = try .date(Date(env, from: value))
            case .generic:
                self = try .object([String: AnyValue](env, from: value))
            }
        case napi_string:
            self = try .string(String(env, from: value))
        case napi_number:
            self = try .number(Double(env, from: value))
        case napi_null:
            self = .null
        case napi_undefined:
            self = .undefined
        default:
            throw Error.unknownType(type.rawValue)
        }
    }

    public init(_ value: some ValueConvertible) throws {
        self = try value.eraseToAny()
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch self {
        case let .object(object): return try object.napiValue(env)
        case let .array(array): return try array.napiValue(env)
        case let .string(string): return try string.napiValue(env)
        case let .number(number): return try number.napiValue(env)
        case let .boolean(boolean): return try boolean.napiValue(env)
        case let .date(date): return try date.napiValue(env)
        case .null: return try Null.default.napiValue(env)
        case .undefined: return try Undefined.default.napiValue(env)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let array = try? container.decode([AnyValue].self) {
            self = .array(array)
        } else if let date = try? container.decode(Date.self) {
            self = .date(date)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if let boolean = try? container.decode(Bool.self) {
            self = .boolean(boolean)
        } else if let object = try? container.decode([String: AnyValue].self) {
            self = .object(object)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Failed to decode value"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .object(object):
            try container.encode(object)
        case let .array(array):
            try container.encode(array)
        case let .string(string):
            try container.encode(string)
        case let .number(number):
            try container.encode(number)
        case let .boolean(bool):
            try container.encode(bool)
        case let .date(date):
            try container.encode(date)
        case .null, .undefined:
            try container.encodeNil()
        }
    }

    public func eraseToAny() throws -> AnyValue {
        self
    }
}

private enum ObjectType {
    case date, array, generic

    init(_ env: napi_env, object: napi_value) throws {
        var isType = false
        try napi_is_date(env, object, &isType).throwIfError()

        if isType {
            self = .date
            return
        }

        try napi_is_array(env, object, &isType).throwIfError()

        if isType {
            self = .array
            return
        }

        self = .generic
    }
}
