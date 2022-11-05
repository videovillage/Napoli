import Foundation
import NAPIC

public class ObjectReference: ValueConvertible {
    enum Error: LocalizedError {
        case envRequired

        var errorDescription: String? {
            switch self {
            case .envRequired:
                return "napi_env was invalidated - you must provide a env when getting or setting a js object"
            }
        }
    }

    private var env: napi_env?
    private let objectValue: napi_value
    private let ref: napi_ref

    fileprivate var cleanupObject: UnsafeMutableRawPointer!

    public convenience init(_ env: napi_env, from: [String: AnyValue]) throws {
        try self.init(env, from: from.napiValue(env))
    }

    public required init(_ env: napi_env, from: napi_value) throws {
        self.env = env
        objectValue = from

        var ref: napi_ref!
        try napi_create_reference(env, from, 1, &ref).throwIfError()
        self.ref = ref

        cleanupObject = Unmanaged<ObjectReference>.passUnretained(self).toOpaque()
        napi_add_env_cleanup_hook(env, envCleanupCallback, cleanupObject)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        objectValue
    }

    func keys(env: napi_env? = nil) throws -> [String] {
        guard let env = env ?? self.env else { throw Error.envRequired }
        var namesArray: napi_value!
        try napi_get_property_names(env, objectValue, &namesArray).throwIfError()
        return try [String](env, from: namesArray)
    }

    func set(_ key: String, value: some ValueConvertible, env: napi_env? = nil) throws {
        guard let env = env ?? self.env else { throw Error.envRequired }
        try napi_set_property(env, objectValue, key.napiValue(env), value.napiValue(env)).throwIfError()
    }

    func get<V: ValueConvertible>(_ key: String, env: napi_env? = nil) throws -> V {
        guard let env = env ?? self.env else { throw Error.envRequired }
        var value: napi_value!
        try napi_get_property(env, objectValue, key.napiValue(env), &value).throwIfError()
        return try V(env, from: value)
    }

    func immutable(_ env: napi_env? = nil) throws -> [String: AnyValue] {
        guard let env = env ?? self.env else { throw Error.envRequired }
        return try .init(env, from: objectValue)
    }

    fileprivate func envCleanup() {
        env = nil
    }

    deinit {
        if let env {
            try! napi_remove_env_cleanup_hook(env, envCleanupCallback, cleanupObject).throwIfError()
            try! napi_delete_reference(env, ref).throwIfError()
        }
    }
}

private func envCleanupCallback(_ pointer: UnsafeMutableRawPointer?) {
    guard let pointer else { return }
    Unmanaged<ObjectReference>.fromOpaque(pointer).takeUnretainedValue().envCleanup()
}
