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
    public init(_: napi_env, from _: napi_value) throws {
        fatalError("Not implemented")
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
    public init(_: napi_env, from _: napi_value) throws {
        fatalError("Not implemented")
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

extension Double: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        self = .nan
        try napi_get_value_double(env, from, &self).throwIfError()
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value?
        try napi_create_double(env, self, &result).throwIfError()
        return result!
    }
}

extension Bool: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        self = false
        try napi_get_value_bool(env, from, &self).throwIfError()
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value?
        try napi_get_boolean(env, self, &result).throwIfError()
        return result!
    }
}
