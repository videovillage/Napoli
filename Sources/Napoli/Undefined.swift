import NAPIC

public struct Undefined: ValueConvertible {
    public static let `default` = Undefined()

    private init() {}

    public init(_ env: Environment, from: napi_value) throws {
        guard try strictlyEquals(env, lhs: from, rhs: Undefined.default) else {
            napi_throw_type_error(env.env, nil, "Expected undefined")
            throw Napoli.Error.pendingException
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        var result: napi_value?

        try napi_get_undefined(env.env, &result).throwIfError()

        return result!
    }
}

extension Undefined: CustomStringConvertible {
    public var description: String {
        "undefined"
    }
}

extension Undefined: Equatable {
    public static func == (_: Undefined, _: Undefined) -> Bool {
        true
    }
}
