import Foundation
import NAPIC

open class Reference: ValueConvertible {
    public let envAccessor: EnvironmentAccessor

    /// be careful!
    @available(*, noasync)
    let storedEnvironment: Environment

    private let internalRef: napi_ref

    /// initializes with a default reference count of 1
    public required init(_ env: Environment, from value: napi_value) throws {
        var result: napi_ref!
        try napi_create_reference(env.env, value, 1, &result).throwIfError()
        internalRef = result!
        envAccessor = try .init(env)
        storedEnvironment = env
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        var result: napi_value!
        try napi_get_reference_value(env.env, internalRef, &result).throwIfError()
        return result
    }

    @discardableResult
    public func unref(_ env: Environment) throws -> UInt32 {
        var result: UInt32 = 0
        try napi_reference_unref(env.env, internalRef, &result).throwIfError()
        return result
    }

    @discardableResult
    func ref(_ env: Environment) throws -> UInt32 {
        var result: UInt32 = 0
        try napi_reference_ref(env.env, internalRef, &result).throwIfError()
        return result
    }

    deinit {
        let internalRef = internalRef
        let envAccessor = envAccessor
        Task {
            try! await envAccessor.withEnvironment { env in
                try napi_delete_reference(env.env, internalRef).throwIfError()
            }
        }
    }
}

open class ObjectReference: Reference {
    public convenience init(_ env: Environment, from: ImmutableObject) throws {
        try self.init(env, from: from.napiValue(env))
    }

    public func keys(_ env: Environment) throws -> [String] {
        var namesArray: napi_value!
        try napi_get_property_names(env.env, napiValue(env), &namesArray).throwIfError()
        return try [String](env, from: namesArray)
    }

    public func keys() async throws -> [String] {
        try await envAccessor.withEnvironment { env in
            try self.keys(env)
        }
    }

    public func set(_ env: Environment, _ key: String, value: some ValueConvertible) throws {
        try napi_set_property(env.env, napiValue(env), key.napiValue(env), value.napiValue(env)).throwIfError()
    }

    public func set(_ key: String, value: some ValueConvertible) async throws {
        try await envAccessor.withEnvironment { env in
            try self.set(env, key, value: value)
        }
    }

    public func get<V: ValueConvertible>(_ env: Environment, _ key: String) throws -> V {
        var value: napi_value!
        try napi_get_property(env.env, napiValue(env), key.napiValue(env), &value).throwIfError()
        return try V(env, from: value)
    }

    public func get<V: ValueConvertible>(_ key: String) async throws -> V {
        try await envAccessor.withEnvironment { env in
            try self.get(env, key)
        }
    }

    public func immutable(_ env: Environment) throws -> ImmutableObject {
        try .init(env, from: napiValue(env))
    }

    public func immutable() async throws -> ImmutableObject {
        try await envAccessor.withEnvironment { env in
            try self.immutable(env)
        }
    }
}
