import NAPIC

public struct Null: ValueConvertible {
    public static let `default` = Null()

    private init() {}

    public init(_ env: napi_env, from: napi_value) throws {
        let null = try Null.default.napiValue(env)

        var result = false
        let status = napi_strict_equals(env, null, from, &result)
        guard status == napi_ok else { throw NAPI.Error(status) }

        guard result == true else {
            napi_throw_type_error(env, nil, "Expected null")
            throw NAPI.Error.pendingException
        }
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value?

        let status = napi_get_null(env, &result)
        guard status == napi_ok else { throw NAPI.Error(status) }

        return result!
    }
}

extension Null: CustomStringConvertible {
    public var description: String {
        return "null"
    }
}

extension Null: Equatable {
    public static func ==(_: Null, _: Null) -> Bool {
        return true
    }
}
