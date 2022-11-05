import Foundation
import NAPIC

/// Here Be Dragons
public protocol ObjectConvertible: ValueConvertible, Codable, Equatable {}

public extension ObjectConvertible {
    init(_ env: napi_env, from: napi_value) throws {
        let object = try [String: AnyValue](env, from: from)
        let encoded = try JSONEncoder().encode(object)
        self = try JSONDecoder().decode(Self.self, from: encoded)
    }

    func napiValue(_ env: napi_env) throws -> napi_value {
        try eraseToAny().napiValue(env)
    }

    func eraseToAny() throws -> AnyValue {
        var result = [String: AnyValue]()

        let mirror = Mirror(reflecting: self)

        for child in mirror.children {
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
