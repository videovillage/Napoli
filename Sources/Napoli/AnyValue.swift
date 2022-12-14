import Foundation
import NAPIC

/// Type-erased `ValueConvertible`
public enum AnyValue: ValueConvertible {
    case object(ImmutableObject)
    case array([AnyValue])
    case arrayBuffer(Data)
    case string(String)
    case number(Double)
    case boolean(Bool)
    case date(Date)
    case error(JSError)
    case null
    case undefined
    case unknown(napi_value)

    enum Error: LocalizedError {
        case unknownType(UInt32)
        case unsupportedObjectType(String)

        var errorDescription: String? {
            switch self {
            case let .unknownType(value):
                return "Initializing AnyValue from unknown type (\(value)) is not supported."
            case let .unsupportedObjectType(value):
                return "Initializing AnyValue from type \(value) is not supported."
            }
        }
    }

    public init(_ env: Environment, from value: napi_value) throws {
        var type: napi_valuetype = napi_undefined
        try napi_typeof(env.env, value, &type).throwIfError()
        switch type {
        case napi_boolean:
            self = try .boolean(Bool(env, from: value))
        case napi_object:
            let objectType = try ObjectType(env, object: value)
            switch objectType {
            case .array:
                self = try .array([AnyValue](env, from: value))
            case .date:
                self = try .date(Date(env, from: value))
            case .generic:
                self = try .object(ImmutableObject(env, from: value))
            case .arrayBuffer:
                self = try .arrayBuffer(Data(env, from: value))
            case .error:
                self = try .error(JSError(env, from: value))
            case .typedArray:
                throw Error.unsupportedObjectType(objectType.rawValue)
            case .dataView:
                throw Error.unsupportedObjectType(objectType.rawValue)
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
            self = .unknown(value)
        }
    }

    public init(_ value: some ValueConvertible) throws {
        self = try value.eraseToAny()
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch self {
        case let .object(object): return try object.napiValue(env)
        case let .array(array): return try array.napiValue(env)
        case let .string(string): return try string.napiValue(env)
        case let .number(number): return try number.napiValue(env)
        case let .boolean(boolean): return try boolean.napiValue(env)
        case let .date(date): return try date.napiValue(env)
        case let .arrayBuffer(data): return try data.napiValue(env)
        case let .error(error): return try error.napiValue(env)
        case .null: return try Null.default.napiValue(env)
        case .undefined: return try Undefined.default.napiValue(env)
        case let .unknown(value): return value
        }
    }

    public init(_ any: AnyValue) {
        self = any
    }

    public func eraseToAny() throws -> AnyValue {
        self
    }
}

private enum ObjectType: String {
    case date, array, typedArray, dataView, arrayBuffer, error, generic

    init(_ env: Environment, object: napi_value) throws {
        if try napiIsDate(env, object) {
            self = .date
        } else if try napiIsArray(env, object) {
            self = .array
        } else if try napiIsTypedArray(env, object) {
            self = .typedArray
        } else if try napiIsDataView(env, object) {
            self = .dataView
        } else if try napiIsArrayBuffer(env, object) {
            self = .arrayBuffer
        } else if try napiIsError(env, object) {
            self = .error
        } else {
            self = .generic
        }
    }
}

func napiIsDate(_ env: Environment, _ value: napi_value) throws -> Bool {
    var isType = false
    try napi_is_date(env.env, value, &isType).throwIfError()
    return isType
}

func napiIsError(_ env: Environment, _ value: napi_value) throws -> Bool {
    var isType = false
    try napi_is_error(env.env, value, &isType).throwIfError()
    return isType
}

func napiIsArray(_ env: Environment, _ value: napi_value) throws -> Bool {
    var isType = false
    try napi_is_array(env.env, value, &isType).throwIfError()
    return isType
}

func napiIsTypedArray(_ env: Environment, _ value: napi_value) throws -> Bool {
    var isType = false
    try napi_is_typedarray(env.env, value, &isType).throwIfError()
    return isType
}

func napiIsDataView(_ env: Environment, _ value: napi_value) throws -> Bool {
    var isType = false
    try napi_is_dataview(env.env, value, &isType).throwIfError()
    return isType
}

func napiIsArrayBuffer(_ env: Environment, _ value: napi_value) throws -> Bool {
    var isType = false
    try napi_is_arraybuffer(env.env, value, &isType).throwIfError()
    return isType
}
