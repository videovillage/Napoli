import Foundation
import NAPIC

public protocol ValueConvertible {
    init(_ env: napi_env, from: napi_value) throws
    func napiValue(_ env: napi_env) throws -> napi_value

    init(_ any: AnyValue) throws
    func eraseToAny() throws -> AnyValue
}

enum AnyValueError: LocalizedError {
    case initNotSupported(type: String, value: String?)
    case erasingNotSupported(type: String, label: String?)

    var errorDescription: String? {
        switch self {
        case let .erasingNotSupported(type, label):
            if let label {
                return "Type-erasing field \"\(label)\" (type \(type)) to AnyValue is not supported."
            } else {
                return "Type-erasing \(type) to AnyValue is not supported."
            }
        case let .initNotSupported(type, value):
            if let value {
                return "Initializing type \(type) from \(value) is not supported."
            } else {
                return "Initializing type \(type) from AnyValue is not supported."
            }
        }
    }

    static func initNotSupported<V: ValueConvertible>(_ selfType: V.Type, from: AnyValue?) -> Self {
        .initNotSupported(type: String(describing: selfType), value: from == nil ? nil : String(describing: from!))
    }
}

public extension ValueConvertible {
    init(_ any: AnyValue) throws {
        throw AnyValueError.initNotSupported(Self.self, from: nil)
    }

    func eraseToAny() throws -> AnyValue {
        throw AnyValueError.erasingNotSupported(type: String(describing: Self.self), label: nil)
    }
}

extension Optional: ValueConvertible where Wrapped: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        if try strictlyEquals(env, lhs: from, rhs: Null.default) {
            self = .none
            return
        }

        if try strictlyEquals(env, lhs: from, rhs: Undefined.default) {
            self = .none
            return
        }

        self = .some(try Wrapped(env, from: from))
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try self?.napiValue(env) ?? Null.default.napiValue(env)
    }

    public init(_ any: AnyValue) throws {
        switch any {
        case .null, .undefined:
            self = .none
        default:
            self = .some(try Wrapped(any))
        }
    }

    public func eraseToAny() throws -> AnyValue {
        switch self {
        case let .some(value):
            return try value.eraseToAny()
        case .none:
            return .null
        }
    }
}

extension Dictionary: ValueConvertible where Key == String, Value: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        var namesArray: napi_value!
        try napi_get_property_names(env, from, &namesArray).throwIfError()

        var count: UInt32 = .zero
        try napi_get_array_length(env, namesArray, &count).throwIfError()

        var dict = Self(minimumCapacity: Int(count))

        for i in 0 ..< count {
            var key: napi_value!
            try napi_get_element(env, namesArray, i, &key).throwIfError()
            var value: napi_value!
            try napi_get_property(env, from, key, &value).throwIfError()

            try dict[String(env, from: key)] = Value(env, from: value)
        }

        self = dict
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value!

        try napi_create_object(env, &result).throwIfError()

        for (key, value) in self {
            try napi_set_property(env, result, try key.napiValue(env), try value.napiValue(env)).throwIfError()
        }

        return result
    }

    public init(_ any: AnyValue) throws {
        switch any {
        case let .object(dict):
            var result = Self.init()
            result.reserveCapacity(dict.count)
            for (key, value) in dict {
                result[key] = try Value(value)
            }
            self = result
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        .object(try mapValues { value in
            try value.eraseToAny()
        })
    }
}

extension Array: ValueConvertible where Element: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        var count: UInt32 = .zero
        try napi_get_array_length(env, from, &count).throwIfError()

        var array = [Element]()
        array.reserveCapacity(Int(count))

        for i in 0 ..< count {
            var result: napi_value!
            try napi_get_element(env, from, i, &result).throwIfError()
            try array.append(Element(env, from: result))
        }

        self = array
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value!

        try napi_create_array_with_length(env, count, &result).throwIfError()

        for (index, element) in enumerated() {
            try napi_set_element(env, result, UInt32(index), try element.napiValue(env)).throwIfError()
        }

        return result
    }

    public init(_ any: AnyValue) throws {
        switch any {
        case let .array(array):
            self = try array.map { try Element($0) }
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        try .array(map { try $0.eraseToAny() })
    }
}

extension String: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        var length = 0

        try napi_get_value_string_utf8(env, from, nil, 0, &length).throwIfError()

        var data = Data(count: length + 1)

        try data.withUnsafeMutableBytes {
            napi_get_value_string_utf8(env, from, $0.baseAddress, length + 1, &length)
        }.throwIfError()

        self.init(data: data.dropLast(), encoding: .utf8)!
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value?
        let data = data(using: .utf8)!

        try data.withUnsafeBytes {
            napi_create_string_utf8(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, &result)
        }.throwIfError()

        return result!
    }

    public init(_ any: AnyValue) throws {
        switch any {
        case let .string(string):
            self = string
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        .string(self)
    }
}

extension Date: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        var timeInterval: Double = .nan
        try napi_get_date_value(env, from, &timeInterval).throwIfError()
        self = Date(timeIntervalSince1970: timeInterval)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value!
        try napi_create_date(env, timeIntervalSince1970, &result).throwIfError()
        return result
    }

    public init(_ any: AnyValue) throws {
        switch any {
        case let .date(date):
            self = date
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        .date(self)
    }
}

extension Double: PrimitiveValueConvertible {
    static let defaultValue = Self.nan
    static let initWithValue = napi_get_value_double
    static let createValue = napi_create_double

    public init(_ any: AnyValue) throws {
        switch any {
        case let .number(number):
            self = number
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        .number(self)
    }
}

extension Int32: PrimitiveValueConvertible {
    static let defaultValue = Self.max
    static let initWithValue = napi_get_value_int32
    static let createValue = napi_create_int32

    public init(_ any: AnyValue) throws {
        switch any {
        case let .number(number):
            self = Self(number)
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        .number(Double(self))
    }
}

extension UInt32: PrimitiveValueConvertible {
    static let defaultValue = Self.max
    static let initWithValue = napi_get_value_uint32
    static let createValue = napi_create_uint32

    public init(_ any: AnyValue) throws {
        switch any {
        case let .number(number):
            self = Self(number)
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        .number(Double(self))
    }
}

extension Int64: ValueConvertible {
    enum JSError: LocalizedError {
        case outOfSafeRange(Int64)

        var errorDescription: String? {
            switch self {
            case let .outOfSafeRange(value):
                return "outside of JS number safe range (\(value))"
            }
        }
    }

    public init(_ env: napi_env, from: napi_value) throws {
        self = Self.max
        try napi_get_value_int64(env, from, &self).throwIfError()

        guard Self.jsSafeRange.contains(self) else {
            throw JSError.outOfSafeRange(self)
        }
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        guard Self.jsSafeRange.contains(self) else {
            throw JSError.outOfSafeRange(self)
        }

        var result: napi_value?
        try napi_create_int64(env, self, &result).throwIfError()
        return result!
    }

    public static let jsSafeRange: ClosedRange<Self> = -(Int64(powl(2, 53)) - 1) ... (Int64(powl(2, 53)) - 1)

    public init(_ any: AnyValue) throws {
        switch any {
        case let .number(number):
            self = Self(number)
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        guard Self.jsSafeRange.contains(self) else {
            throw JSError.outOfSafeRange(self)
        }

        return .number(Double(self))
    }
}

extension Bool: PrimitiveValueConvertible {
    static let defaultValue = false
    static let initWithValue = napi_get_value_bool
    static let createValue = napi_get_boolean

    public init(_ any: AnyValue) throws {
        switch any {
        case let .boolean(bool):
            self = bool
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        .boolean(self)
    }
}

protocol PrimitiveValueConvertible: ValueConvertible {
    static var defaultValue: Self { get }
    static var initWithValue: (_ env: napi_env?, _ value: napi_value?, _ result: UnsafeMutablePointer<Self>?) -> napi_status { get }
    static var createValue: (_ env: napi_env?, _ value: Self, _ result: UnsafeMutablePointer<napi_value?>?) -> napi_status { get }
}

extension PrimitiveValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        self = Self.defaultValue
        try Self.initWithValue(env, from, &self).throwIfError()
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value?
        try Self.createValue(env, self, &result).throwIfError()
        return result!
    }
}
