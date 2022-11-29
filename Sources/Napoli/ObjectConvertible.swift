import Foundation
import NAPIC

/// Here Be Dragons
public protocol ObjectConvertible: ValueConvertible, Codable {}

public extension ObjectConvertible {
    init(_ env: Environment, from: napi_value) throws {
        let object = try ImmutableObject(env, from: from)
        let data = try Data(env.global().json().stringify(object).utf8)
        self = try JSONDecoder().decode(Self.self, from: data)
    }

    func napiValue(_ env: Environment) throws -> napi_value {
        try eraseToAny().napiValue(env)
    }

    func eraseToAny() throws -> AnyValue {
        var result = ImmutableObject()

        for child in Mirror(reflecting: self).children {
            guard
                let label = child.label,
                let value = child.value as? ValueConvertible
            else {
                throw AnyValueError.erasingNotSupported(type: String(describing: type(of: child.value)), label: child.label)
            }

            result[label] = try value.eraseToAny()
        }

        return .object(result)
    }
}
