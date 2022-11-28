import Foundation
import NAPIC

open class ObjectReference: ValueConvertible {
    private let ref: napi_ref
    private let envAccessor: EnvironmentAccessor

    fileprivate var cleanupObject: UnsafeMutableRawPointer!

    public convenience init(_ env: Environment, from: [String: AnyValue]) throws {
        try self.init(env, from: from.napiValue(env))
    }

    public required init(_ env: Environment, from: napi_value) throws {
        ref = try createReference(env, from: from, initialRefCount: 1)
        envAccessor = try EnvironmentAccessor(env)
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        try getReferenceValue(env, ref: ref)
    }

    public func keys(_ env: Environment) throws -> [String] {
        var namesArray: napi_value!
        try napi_get_property_names(env.env, getReferenceValue(env, ref: ref), &namesArray).throwIfError()
        return try [String](env, from: namesArray)
    }

    public func keys() async throws -> [String] {
        let ref = ref
        return try await envAccessor.withEnvironment { env in
            var namesArray: napi_value!
            try napi_get_property_names(env.env, getReferenceValue(env, ref: ref), &namesArray).throwIfError()
            return try [String](env, from: namesArray)
        }
    }

    public func set(_ env: Environment, _ key: String, value: some ValueConvertible) throws {
        try napi_set_property(env.env, getReferenceValue(env, ref: ref), key.napiValue(env), value.napiValue(env)).throwIfError()
    }

    public func set(_ key: String, value: some ValueConvertible) async throws {
        let ref = ref
        try await envAccessor.withEnvironment { env in
            try napi_set_property(env.env, getReferenceValue(env, ref: ref), key.napiValue(env), value.napiValue(env)).throwIfError()
        }
    }

    public func get<V: ValueConvertible>(_ env: Environment, _ key: String) throws -> V {
        var value: napi_value!
        try napi_get_property(env.env, getReferenceValue(env, ref: ref), key.napiValue(env), &value).throwIfError()
        return try V(env, from: value)
    }

    public func get<V: ValueConvertible>(_ key: String) async throws -> V {
        let ref = ref
        return try await envAccessor.withEnvironment { env in
            var value: napi_value!
            try napi_get_property(env.env, getReferenceValue(env, ref: ref), key.napiValue(env), &value).throwIfError()
            return try V(env, from: value)
        }
    }

    public func immutable(_ env: Environment) throws -> [String: AnyValue] {
        try .init(env, from: getReferenceValue(env, ref: ref))
    }

    public func immutable() async throws -> [String: AnyValue] {
        let ref = self.ref
        return try await envAccessor.withEnvironment { env in
            try [String: AnyValue](env, from: getReferenceValue(env, ref: ref))
        }
    }

    deinit {
        let envAccessor = envAccessor
        let ref = ref
        Task {
            try! await envAccessor.withEnvironment { env in
                try deleteReference(env, ref: ref)
            }
        }
    }
}

func createReference(_ env: Environment, from: napi_value, initialRefCount: UInt32) throws -> napi_ref {
    var result: napi_ref!
    try napi_create_reference(env.env, from, initialRefCount, &result).throwIfError()
    return result
}

func getReferenceValue(_ env: Environment, ref: napi_ref) throws -> napi_value {
    var result: napi_value!
    try napi_get_reference_value(env.env, ref, &result).throwIfError()
    return result
}

@discardableResult
func unref(_ env: Environment, ref: napi_ref) throws -> UInt32 {
    var result: UInt32 = 0
    try napi_reference_unref(env.env, ref, &result).throwIfError()
    return result
}

@discardableResult
func ref(_ env: Environment, ref: napi_ref) throws -> UInt32 {
    var result: UInt32 = 0
    try napi_reference_ref(env.env, ref, &result).throwIfError()
    return result
}

func deleteReference(_ env: Environment, ref: napi_ref) throws {
    try napi_delete_reference(env.env, ref).throwIfError()
}
