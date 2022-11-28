import Foundation
import NAPIC

@available(*, noasync)
open class ObjectReference: ValueConvertible {
    private var env: Environment?
    private let ref: napi_ref

    fileprivate var cleanupObject: UnsafeMutableRawPointer!

    public convenience init(_ env: Environment, from: [String: AnyValue]) throws {
        try self.init(env, from: from.napiValue(env))
    }

    public required init(_ env: Environment, from: napi_value) throws {
        self.env = env
        ref = try createReference(env, from: from, initialRefCount: 1)
        cleanupObject = Unmanaged<ObjectReference>.passUnretained(self).toOpaque()
        napi_add_env_cleanup_hook(env.env, envCleanupCallback, cleanupObject)
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        try getReferenceValue(env, ref: ref)
    }

    public func keys(_ env: Environment) throws -> [String] {
        var namesArray: napi_value!
        try napi_get_property_names(env.env, getReferenceValue(env, ref: ref), &namesArray).throwIfError()
        return try [String](env, from: namesArray)
    }

    public func set(_ env: Environment, _ key: String, value: some ValueConvertible) throws {
        try napi_set_property(env.env, getReferenceValue(env, ref: ref), key.napiValue(env), value.napiValue(env)).throwIfError()
    }

    public func get<V: ValueConvertible>(_ env: Environment, _ key: String) throws -> V {
        var value: napi_value!
        try napi_get_property(env.env, getReferenceValue(env, ref: ref), key.napiValue(env), &value).throwIfError()
        return try V(env, from: value)
    }

    public func immutable(_ env: Environment) throws -> [String: AnyValue] {
        try .init(env, from: getReferenceValue(env, ref: ref))
    }

    fileprivate func envCleanup() {
        env = nil
    }

    deinit {
        try! deleteReference(env!, ref: ref)
        try! napi_remove_env_cleanup_hook(env!.env, envCleanupCallback, cleanupObject).throwIfError()
    }
}

private func envCleanupCallback(_ pointer: UnsafeMutableRawPointer?) {
    guard let pointer else { return }
    Unmanaged<ObjectReference>.fromOpaque(pointer).takeUnretainedValue().envCleanup()
}

open class ThreadsafeObjectReference: ValueConvertible {
    private typealias KeysGetter = ThreadsafeTypedFunction0<[String]>
    private typealias Setter = ThreadsafeTypedFunction2<Undefined, String, AnyValue>
    private typealias Getter = ThreadsafeTypedFunction1<AnyValue, String>
    private typealias ImmutableGetter = ThreadsafeTypedFunction0<[String: AnyValue]>
    private typealias DeinitCallback = ThreadsafeTypedFunction0<Undefined>

    private let ref: napi_ref
    private let keysGetter: KeysGetter
    private let setter: Setter
    private let getter: Getter
    private let immutableGetter: ImmutableGetter
    private let deinitCallback: DeinitCallback

    public convenience init(_ env: Environment, from: [String: AnyValue]) throws {
        try self.init(env, from: from.napiValue(env))
    }

    public required init(_ env: Environment, from: napi_value) throws {
        ref = try createReference(env, from: from, initialRefCount: 1)
        keysGetter = try Self.keysGetter(env, ref: ref)
        setter = try Self.setter(env, ref: ref)
        getter = try Self.getter(env, ref: ref)
        immutableGetter = try Self.immutableGetter(env, ref: ref)
        deinitCallback = try Self.deinitCallback(env, ref: ref)
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        try getReferenceValue(env, ref: ref)
    }

    public func keys() async throws -> [String] {
        try await keysGetter.call()
    }

    public func set(_ key: String, value: some ValueConvertible) async throws {
        try await setter.call(key, value.eraseToAny())
    }

    public func get<V: ValueConvertible>(_ key: String) async throws -> V {
        try await V(getter.call(key))
    }

    public func immutable() async throws -> [String: AnyValue] {
        try await immutableGetter.call()
    }

    deinit {
        let callback = deinitCallback
        Task {
            try! await callback.call()
        }
    }

    private static func keysGetter(_ env: Environment, ref: napi_ref) throws -> KeysGetter {
        try .init(env, .init(named: "keysGetter") { env, _, _ in
            var namesArray: napi_value!
            try napi_get_property_names(env.env, getReferenceValue(env, ref: ref), &namesArray).throwIfError()
            return try [String](env, from: namesArray)
        })
    }

    private static func setter(_ env: Environment, ref: napi_ref) throws -> Setter {
        try .init(env, .init(named: "setter") { env, _, args in
            try napi_set_property(env.env, getReferenceValue(env, ref: ref), args[0], args[1]).throwIfError()
            return Undefined.default
        })
    }

    private static func getter(_ env: Environment, ref: napi_ref) throws -> Getter {
        try .init(env, .init(named: "getter") { env, _, args in
            var value: napi_value!
            try napi_get_property(env.env, getReferenceValue(env, ref: ref), args[0], &value).throwIfError()
            return try AnyValue(env, from: value)
        })
    }

    private static func immutableGetter(_ env: Environment, ref: napi_ref) throws -> ImmutableGetter {
        try .init(env, .init(named: "immutableGetter") { env, _, _ in
            try [String: AnyValue](env, from: getReferenceValue(env, ref: ref))
        })
    }

    private static func deinitCallback(_ env: Environment, ref: napi_ref) throws -> DeinitCallback {
        try .init(env, .init(named: "deinit") { env, _, _ in
            try deleteReference(env, ref: ref)
            return Undefined.default
        })
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
