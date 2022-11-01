import Foundation
import NAPIC

public class Promise<Result>: ValueConvertible {
    public typealias Closure = () async throws -> ValueConvertible

    public required init(_: napi_env, from _: napi_value) throws {
        fatalError("not implemented")
    }

    private var deferred: ThreadSafeDeferred!
    private let closure: Closure

    public init(_ closure: @escaping Closure) where Result: ValueConvertible {
        self.closure = closure
    }

    public init(_ closure: @escaping () async throws -> Void) where Result == Void {
        self.closure = {
            try await closure()
            return Undefined.default
        }
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var promise: napi_value!
        deferred = try .init(env, &promise)
        Task {
            do {
                let result = try await closure()
                try! await deferred.resolve(result)
            } catch {
                try! await deferred.reject(error)
            }
        }

        return promise
    }
}

public actor ThreadSafeDeferred {
    private class Storage {
        var result: Result<ValueConvertible, Swift.Error>?
    }

    private let finalize: ThreadsafeFunction
    private let storage: Storage

    public init(_ env: napi_env, _ promise: UnsafeMutablePointer<napi_value?>!) throws {
        let storage = Storage()
        var deferred: napi_deferred!
        try napi_create_promise(env, &deferred, promise).throwIfError()

        self.storage = storage

        finalize = try .init(env, Function(named: "ThreadSafeDeferred") { (env: napi_env) in
            do {
                let success = try storage.result!.get().napiValue(env)
                try! napi_resolve_deferred(env, deferred, success).throwIfError()
            } catch {
                var jsError: napi_value!
                try! napi_create_error(env,
                                       "swift_promise_internal".napiValue(env),
                                       error.localizedDescription.napiValue(env),
                                       &jsError).throwIfError()
                try! napi_reject_deferred(env, deferred, jsError).throwIfError()
            }
        })
    }

    func resolve(_ value: ValueConvertible) async throws {
        guard storage.result == nil else { fatalError("tried resolving a finalized deferred object") }

        storage.result = .success(value)
        try await finalize.call()
    }

    func reject(_ error: Swift.Error) async throws {
        guard storage.result == nil else { fatalError("tried rejecting a finalized deferred object") }

        storage.result = .failure(error)
        try await finalize.call()
    }
}
