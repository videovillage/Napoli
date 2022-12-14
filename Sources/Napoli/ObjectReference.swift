import Foundation
import NAPIC

/// initializes with a weak reference to the underlying `napi_value` - if you need a strong reference, call `ref()`
open class Reference: ValueConvertible {
    public let envAccessor: EnvironmentAccessor

    /// be careful!
    @available(*, noasync)
    let storedEnvironment: Environment

    private let internalRef: napi_ref

    public required init(_ env: Environment, from value: napi_value) throws {
        var result: napi_ref!
        try napi_create_reference(env.env, value, 0, &result).throwIfError()
        internalRef = result!
        envAccessor = try .init(env)
        storedEnvironment = env
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        var result: napi_value!
        try napi_get_reference_value(env.env, internalRef, &result).throwIfError()
        return result
    }

    @available(*, noasync)
    @discardableResult
    public func unref(env: Environment? = nil) throws -> UInt32 {
        let env = env ?? storedEnvironment
        var result: UInt32 = 0
        try napi_reference_unref(env.env, internalRef, &result).throwIfError()
        return result
    }

    @discardableResult
    public func unref() async throws -> UInt32 {
        try await withEnvironment { env in
            try self.unref(env: env)
        }
    }

    @available(*, noasync)
    @discardableResult
    public func ref(env: Environment? = nil) throws -> UInt32 {
        let env = env ?? storedEnvironment
        var result: UInt32 = 0
        try napi_reference_ref(env.env, internalRef, &result).throwIfError()
        return result
    }

    @discardableResult
    public func ref() async throws -> UInt32 {
        try await withEnvironment { env in
            try self.ref(env: env)
        }
    }

    public func withEnvironment<T>(_ closure: @escaping (Environment) throws -> T) async throws -> T {
        try await envAccessor.withEnvironment(closure)
    }

    deinit {
        if Thread.isJSThread {
            try! napi_delete_reference(storedEnvironment.env, internalRef).throwIfError()
        } else {
            let internalRef = internalRef
            let envAccessor = envAccessor
            Task {
                try! await envAccessor.withEnvironment { env in
                    try napi_delete_reference(env.env, internalRef).throwIfError()
                }
            }
        }
    }
}

open class ObjectReference: Reference {
    public convenience init(_ env: Environment, from: ImmutableObject) throws {
        try self.init(env, from: from.napiValue(env))
    }

    @available(*, noasync)
    public func propertyNames(_ env: Environment? = nil) throws -> [String] {
        let env = env ?? storedEnvironment
        var namesArray: napi_value!
        try napi_get_all_property_names(env.env,
                                        napiValue(env),
                                        napi_key_include_prototypes,
                                        napi_key_all_properties,
                                        napi_key_numbers_to_strings,
                                        &namesArray).throwIfError()
        var count: UInt32 = .zero
        try napi_get_array_length(env.env, namesArray, &count).throwIfError()
        var keys = [String]()

        for i in 0 ..< count {
            let scope = try Scope.open(env)
            defer { scope.close(env) }
            var key: napi_value!
            try napi_get_element(env.env, namesArray, i, &key).throwIfError()

            if let key = try? String(env, from: key) {
                keys.append(key)
            }
        }

        return keys
    }

    public func propertyNames() async throws -> [String] {
        try await withEnvironment { env in
            try self.propertyNames(env)
        }
    }

    @available(*, noasync)
    public func set(env: Environment? = nil, _ key: String, value: some ValueConvertible) throws {
        let env = env ?? storedEnvironment
        try napi_set_property(env.env, napiValue(env), key.napiValue(env), value.napiValue(env)).throwIfError()
    }

    public func set(_ key: String, value: some ValueConvertible) async throws {
        try await withEnvironment { env in
            try self.set(env: env, key, value: value)
        }
    }

    @available(*, noasync)
    public func get<V: ValueConvertible>(env: Environment? = nil, _ key: String) throws -> V {
        let env = env ?? storedEnvironment
        var value: napi_value!
        try napi_get_property(env.env, napiValue(env), key.napiValue(env), &value).throwIfError()
        return try V(env, from: value)
    }

    public func get<V: ValueConvertible>(_ key: String) async throws -> V {
        try await withEnvironment { env in
            try self.get(env: env, key)
        }
    }

    @available(*, noasync)
    public func immutable(env: Environment? = nil) throws -> ImmutableObject {
        let env = env ?? storedEnvironment
        return try .init(env, from: napiValue(env))
    }

    public func immutable() async throws -> ImmutableObject {
        try await withEnvironment { env in
            try self.immutable(env: env)
        }
    }
}
