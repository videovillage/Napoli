import Foundation
import NAPIC

public protocol ValueConvertible {
    init(_ env: napi_env, from: napi_value) throws
    func napiValue(_ env: napi_env) throws -> napi_value
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
        try self?.napiValue(env) ?? Value.null.napiValue(env)
    }
}

extension Dictionary: ValueConvertible where Key == String, Value: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        var namesArray: napi_value!
        try napi_get_property_names(env, from, &namesArray).throwIfError()

        var count: UInt32 = .zero
        try napi_get_array_length(env, namesArray, &count).throwIfError()

        var dict = Self.init(minimumCapacity: Int(count))

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
}

extension Date: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        var timeInterval: Double!
        try napi_get_date_value(env, from, &timeInterval).throwIfError()
        self = Date(timeIntervalSince1970: timeInterval)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value!
        try napi_create_date(env, timeIntervalSince1970, &result).throwIfError()
        return result
    }
}

extension Double: PrimitiveValueConvertible {
    static let defaultValue = Self.nan
    static let initWithValue = napi_get_value_double
    static let getValue = napi_create_double
}

extension Int32: PrimitiveValueConvertible {
    static let defaultValue = Self.max
    static let initWithValue = napi_get_value_int32
    static let getValue = napi_create_int32
}

extension UInt32: PrimitiveValueConvertible {
    static let defaultValue = Self.max
    static let initWithValue = napi_get_value_uint32
    static let getValue = napi_create_uint32
}

extension Int64: PrimitiveValueConvertible {
    static let defaultValue = Self.max
    static let initWithValue = napi_get_value_int64
    static let getValue = napi_create_int64
}

extension Bool: PrimitiveValueConvertible {
    static let defaultValue = false
    static let initWithValue = napi_get_value_bool
    static let getValue = napi_get_boolean
}

protocol PrimitiveValueConvertible: ValueConvertible {
    static var defaultValue: Self { get }
    static var initWithValue: (_ env: napi_env?, _ value: napi_value?, _ result: UnsafeMutablePointer<Self>?) -> napi_status { get }
    static var getValue: (_ env: napi_env?, _ value: Self, _ result: UnsafeMutablePointer<napi_value?>?) -> napi_status { get }
}

extension PrimitiveValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        self = Self.defaultValue
        try Self.initWithValue(env, from, &self).throwIfError()
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value?
        try Self.getValue(env, self, &result).throwIfError()
        return result!
    }
}
