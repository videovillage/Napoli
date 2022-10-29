import NAPIC
import Foundation

public class Promise: ValueConvertible {
    public typealias Closure = () async throws -> ValueConvertible
    public typealias NoResultClosure = () async throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        fatalError("not implemented")
    }

    let deferred: ThreadSafeDeferred
    let closure: Closure

    public init(_ env: napi_env, _ closure: @escaping Closure) throws {
        self.deferred = try .init(env)
        self.closure = closure
    }

    public init(_ env: napi_env, _ closure: @escaping NoResultClosure) throws {
        self.deferred = try .init(env)
        self.closure = {
            try await closure()
            return Value.undefined
        }
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        Task {
            do {
                let result = try await closure()
                try! await deferred.resolve(result)
            } catch {
                try! await deferred.reject(error)
            }
        }

        return deferred.promise
    }
}

public class ThreadSafeDeferred {
    private class Storage {
        var result: Result<ValueConvertible, Swift.Error>?
    }

    private let finalize: ThreadsafeFunction
    private(set) var promise: napi_value! = nil
    private let storage: Storage

    public init(_ env: napi_env) throws {
        let storage = Storage()
        var deferred: napi_deferred! = nil
        try napi_create_promise(env, &deferred, &promise).throwIfError()

        self.storage = storage

        finalize = try .init(env, Function(named: "ThreadSafeDeferred", { (env: napi_env) in
            do {
                let success = try storage.result!.get().napiValue(env)
                try! napi_resolve_deferred(env, deferred, success).throwIfError()
            } catch {
                var jsError: napi_value! = nil
                try! napi_create_error(env,
                                       "swift_promise_internal".napiValue(env),
                                       error.localizedDescription.napiValue(env),
                                       &jsError).throwIfError()
                try! napi_reject_deferred(env, deferred, jsError).throwIfError()
            }
        }))
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
