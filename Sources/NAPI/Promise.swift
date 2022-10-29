import NAPIC
import Foundation

public class ThreadSafeDeferred {
    private class Storage {
        var result: Result<ValueConvertible, Swift.Error>?
    }

    private let finalize: ThreadsafeFunction
    private(set) var promise: napi_value! = nil
    private let storage: Storage

    public init(_ env: napi_env) throws {
        var storage = Storage()
        var deferred: napi_deferred! = nil
        try napi_create_promise(env, &deferred, &promise).throwIfError()

        self.storage = storage

        finalize = try .init(env, Function(named: "ThreadSafeDeferred", { (env: napi_env) in
            do {
                let success = try storage.result!.get().napiValue(env)
                try napi_resolve_deferred(env, deferred, success).throwIfError()
            } catch {
                try napi_reject_deferred(env, deferred, Value.undefined.napiValue(env)).throwIfError()
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
