import Foundation
import NAPIC

/// Here Be Dragons
public protocol ImmutableObjectConvertible: ValueConvertible, Codable {}

public struct GenericNAPIValue: ValueConvertible {
    public let value: napi_value

    public init(_: Environment, from: napi_value) throws {
        value = from
    }

    public func napiValue(_: Environment) throws -> napi_value {
        value
    }
}

public extension ImmutableObjectConvertible {
    init(_ env: Environment, from: napi_value) throws {
        let object = try ImmutableObject(env, from: from)
        let jsonString = try env.global().json().stringify(object)
        let data = Data(jsonString.utf8)
        self = try JSONDecoder().decode(Self.self, from: data)
    }

    func napiValue(_ env: Environment) throws -> napi_value {
        let jsonString = try String(data: JSONEncoder().encode(self), encoding: .utf8)!
        let result: GenericNAPIValue = try env.global().json().parse(jsonString)
        return result.value
    }
}
