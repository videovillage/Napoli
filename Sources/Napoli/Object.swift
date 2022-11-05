import Foundation
import NAPIC

public class Object: ValueConvertible {
    enum Error: LocalizedError {
        case envRequired

        var errorDescription: String? {
            switch self {
            case .envRequired:
                return "napi_env required when getting or setting a js object"
            }
        }
    }

    private enum Storage {
        case javascript(napi_value)
        case swift([String: AnyValue])
    }

    private var storage: Storage

    public init(_: [String: AnyValue]) {
        storage = .swift(.init())
    }

    public required init(_: napi_env, from: napi_value) throws {
        storage = .javascript(from)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch storage {
        case let .javascript(value):
            return value
        case let .swift(dict):
            return try dict.napiValue(env)
        }
    }

    func keys(env: napi_env? = nil) throws -> [String] {
        switch storage {
        case let .javascript(value):
            guard let env else { throw Error.envRequired }
            var namesArray: napi_value!
            try napi_get_property_names(env, value, &namesArray).throwIfError()
            return try [String](env, from: namesArray)
        case let .swift(dict):
            return [String](dict.keys)
        }
    }

    func set(_ key: String, value: some ValueConvertible, env: napi_env? = nil) throws {
        switch storage {
        case let .javascript(object):
            guard let env else { throw Error.envRequired }
            try napi_set_property(env, object, key.napiValue(env), value.napiValue(env)).throwIfError()
        case var .swift(dict):
            dict[key] = try value.eraseToAny()
            storage = .swift(dict)
        }
    }

    func get<V: ValueConvertible>(_ key: String, env: napi_env? = nil) throws -> V {
        switch storage {
        case let .javascript(object):
            guard let env else { throw Error.envRequired }
            var value: napi_value!
            try napi_get_property(env, object, key.napiValue(env), &value).throwIfError()
            return try V(env, from: value)
        case let .swift(dict):
            return try V(dict[key] ?? .undefined)
        }
    }
}
