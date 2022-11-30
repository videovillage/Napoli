import NAPIC

public struct Null: ValueConvertible {
    public static let `default` = Null()

    private init() {}

    public init(_ env: Environment, from: napi_value) throws {
        guard try strictlyEquals(env, lhs: from, rhs: Null.default) else {
            napi_throw_type_error(env.env, nil, "Expected null")
            throw NAPIError.pendingException
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        var result: napi_value?

        try napi_get_null(env.env, &result).throwIfError()

        return result!
    }
}

extension Null: CustomStringConvertible {
    public var description: String {
        "null"
    }
}

extension Null: Equatable {
    public static func == (_: Null, _: Null) -> Bool {
        true
    }
}
