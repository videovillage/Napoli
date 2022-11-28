import Foundation
import NAPIC

public class Promise<Result: ValueConvertible>: ValueConvertible {
    public required init(_: Environment, from _: napi_value) throws {
        fatalError("not implemented")
    }

    private var deferred: ThreadSafeDeferred!
    private let task: Task<ValueConvertible, Swift.Error>

    public init(_ closure: @escaping () async throws -> Result) {
        task = Task {
            try await closure()
        }
    }

    public init(_ closure: @escaping () async throws -> Void) where Result == Undefined {
        task = Task {
            try await closure()
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        var promise: napi_value!
        deferred = try .init(env, &promise)
        Task {
            do {
                let result = try await task.result.get()
                try! await deferred.resolve(result)
            } catch {
                try! await deferred.reject(error)
            }
        }

        return promise
    }
}

private actor ThreadSafeDeferred {
    private class Storage {
        var result: Result<ValueConvertible, Swift.Error>?
    }

    private let finalize: ThreadsafeTypedFunction0<Undefined>
    private let storage: Storage

    public init(_ env: Environment, _ promise: UnsafeMutablePointer<napi_value?>!) throws {
        let storage = Storage()
        var deferred: napi_deferred!
        try napi_create_promise(env.env, &deferred, promise).throwIfError()

        self.storage = storage

        finalize = try .init(env, .init(named: "ThreadSafeDeferred") { (env: Environment, _, _) in
            do {
                let success = try storage.result!.get().napiValue(env)
                try! napi_resolve_deferred(env.env, deferred, success).throwIfError()
            } catch let error as ErrorConvertible {
                var jsError: napi_value!
                try! napi_create_error(env.env,
                                       error.code.napiValue(env),
                                       error.message.napiValue(env),
                                       &jsError).throwIfError()
                try! napi_reject_deferred(env.env, deferred, jsError).throwIfError()
            } catch {
                var jsError: napi_value!
                try! napi_create_error(env.env,
                                       "swift_promise_internal".napiValue(env),
                                       error.localizedDescription.napiValue(env),
                                       &jsError).throwIfError()
                try! napi_reject_deferred(env.env, deferred, jsError).throwIfError()
            }
            return Undefined.default
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
