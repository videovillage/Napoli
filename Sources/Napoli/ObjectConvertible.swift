import Foundation
import NAPIC

/// Here Be Dragons
public protocol ObjectConvertible: ValueConvertible, Codable, Equatable {}

public extension ObjectConvertible {
    init(_ env: napi_env, from: napi_value) throws {
        fatalError("not supported")
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

        fatalError("not supported")
    }
}
