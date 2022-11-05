import Foundation
import NAPIC

public class Object: ValueConvertible {
    enum Error: LocalizedError {
        case envRequired

        var errorDescription: String? {
            switch self {
            case .envRequired:
                return "napi_env was invalidated - you must provide a env when getting or setting a js object"
            }
        }
    }

    fileprivate enum Storage {
        case javascript(napi_env?, napi_value)
        case swift([String: AnyValue])
    }

    fileprivate var storage: Storage
    fileprivate var cleanupObject: UnsafeMutableRawPointer!

    public convenience init(_ dict: [String: AnyValue] = [:]) {
        self.init(.swift(dict))
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        self.init(.javascript(env, from))
    }

    private init(_ storage: Storage) {
        self.storage = storage

        switch storage {
        case let .javascript(env, _):
            guard let env else { return }
            cleanupObject = Unmanaged<Object>.passUnretained(self).toOpaque()
            napi_add_env_cleanup_hook(env, envCleanup, cleanupObject)
        default:
            break
        }
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch storage {
        case let .javascript(_, value):
            return value
        case let .swift(dict):
            var result: napi_value!
            try napi_create_object(env, &result).throwIfError()
            for (key, value) in dict {
                try napi_set_property(env, result, try key.napiValue(env), try value.napiValue(env)).throwIfError()
            }
            return result
        }
    }

    func keys(env: napi_env? = nil) throws -> [String] {
        switch storage {
        case let .javascript(frozenEnv, value):
            guard let env = env ?? frozenEnv else { throw Error.envRequired }
            var namesArray: napi_value!
            try napi_get_property_names(env, value, &namesArray).throwIfError()
            return try [String](env, from: namesArray)
        case let .swift(dict):
            return [String](dict.keys)
        }
    }

    func set(_ key: String, value: some ValueConvertible, env: napi_env? = nil) throws {
        switch storage {
        case let .javascript(frozenEnv, object):
            guard let env = env ?? frozenEnv else { throw Error.envRequired }
            try napi_set_property(env, object, key.napiValue(env), value.napiValue(env)).throwIfError()
        case var .swift(dict):
            dict[key] = try value.eraseToAny()
            storage = .swift(dict)
        }
    }

    func get<V: ValueConvertible>(_ key: String, env: napi_env? = nil) throws -> V {
        switch storage {
        case let .javascript(frozenEnv, object):
            guard let env = env ?? frozenEnv else { throw Error.envRequired }
            var value: napi_value!
            try napi_get_property(env, object, key.napiValue(env), &value).throwIfError()
            return try V(env, from: value)
        case let .swift(dict):
            return try V(dict[key] ?? .undefined)
        }
    }

    func frozen(_ env: napi_env? = nil) throws -> [String: AnyValue] {
        switch storage {
        case let .javascript(frozenEnv, from):
            guard let env = env ?? frozenEnv else { throw Error.envRequired }
            var namesArray: napi_value!
            try napi_get_property_names(env, from, &namesArray).throwIfError()

            var count: UInt32 = .zero
            try napi_get_array_length(env, namesArray, &count).throwIfError()

            var dict = [String: AnyValue](minimumCapacity: Int(count))

            for i in 0 ..< count {
                var key: napi_value!
                try napi_get_element(env, namesArray, i, &key).throwIfError()
                var value: napi_value!
                try napi_get_property(env, from, key, &value).throwIfError()

                try dict[String(env, from: key)] = .init(env, from: value)
            }

            return dict
        case let .swift(dict):
            return dict
        }
    }

    public required convenience init(_ any: AnyValue) throws {
        switch any {
        case let .object(object):
            self.init(object.storage)
        default:
            throw AnyValueError.initNotSupported(Self.self, from: any)
        }
    }

    public func eraseToAny() throws -> AnyValue {
        .object(self)
    }

    deinit {
        switch storage {
        case let .javascript(env, _):
            guard let env else { return }
            napi_remove_env_cleanup_hook(env, envCleanup, cleanupObject)
        default:
            break
        }
    }
}

private func envCleanup(_ pointer: UnsafeMutableRawPointer?) {
    guard let pointer else { return }
    let object = Unmanaged<Object>.fromOpaque(pointer).takeUnretainedValue()

    switch object.storage {
    case let .javascript(_, value):
        object.storage = .javascript(nil, value)
    default:
        break
    }
}
