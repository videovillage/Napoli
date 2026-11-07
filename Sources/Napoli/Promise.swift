import Foundation
import NAPIC

public typealias VoidPromise = Promise<Undefined>

private class JSPromise: ObjectReference {
    required init(_ env: Environment, from value: napi_value) throws {
        try super.init(env, from: value)
        try attachDummyCatch(env)
    }

    @available(*, noasync)
    func attachDummyCatch(_ env: Environment? = nil) throws {
        typealias CatchCallback = TypedFunction1<Undefined, JSError>
        try callSelf(env: env, "catch", CatchCallback(named: "dummyCatch") { _, _ in })
    }

    @available(*, noasync)
    func then<V: ValueConvertible>(_ env: Environment? = nil, onFulfilled: @escaping (Environment, V) -> Void, onReject: @escaping (Environment, JSError) -> Void) throws {
        typealias OnFullfillCallback = TypedFunction1<Undefined, V>
        typealias OnRejectCallback = TypedFunction1<Undefined, JSError>
        try callSelf(env: env,
                     "then",
                     OnFullfillCallback(named: "onFulfilled", onFulfilled),
                     OnRejectCallback(named: "onReject", onReject))
    }

    func then<V: ValueConvertible>(onFulfilled: @escaping (Environment, V) -> Void, onReject: @escaping (Environment, JSError) -> Void) async throws {
        typealias OnFullfillCallback = TypedFunction1<Undefined, V>
        typealias OnRejectCallback = TypedFunction1<Undefined, JSError>
        try await callSelf("then",
                           OnFullfillCallback(named: "onFulfilled", onFulfilled),
                           OnRejectCallback(named: "onReject", onReject))
    }

    func getValue<V: ValueConvertible>() async throws -> V {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    try await self.then(onFulfilled: { _, value in
                                            continuation.resume(returning: value)
                                        },
                                        onReject: { _, error in
                                            continuation.resume(throwing: error)
                                        })
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

public class Promise<Result: ValueConvertible>: ValueConvertible {
    private enum Storage {
        case javascript(JSPromise, Task<Result, Error>)
        case swift(Task<Result, Error>)
    }

    private let storage: Storage

    public required init(_ env: Environment, from: napi_value) throws {
        let promise = try JSPromise(env, from: from)
        storage = .javascript(promise, Task {
            try await promise.getValue()
        })
    }

    public init(_ closure: @escaping () async throws -> Result) {
        storage = .swift(Task {
            try await closure()
        })
    }

    public init(_ closure: @escaping () async throws -> Void) where Result == Undefined {
        storage = .swift(Task {
            try await closure()
            return Undefined.default
        })
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch storage {
        case let .javascript(ref, _):
            return try ref.napiValue(env)
        case let .swift(task):
            var promise: napi_value!
            let deferred = try ThreadSafeDeferred(env, &promise)
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

    public var value: Result {
        get async throws {
            switch storage {
            case let .javascript(_, task):
                return try await task.value
            case let .swift(task):
                return try await task.value
            }
        }
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
                try! napi_reject_deferred(env.env,
                                          deferred,
                                          JSError(code: error.code,
                                                  message: error.message).napiValue(env)).throwIfError()
            } catch {
                try! napi_reject_deferred(env.env,
                                          deferred,
                                          JSError(code: "ERR_SWIFT_PROMISE_INTERNAL",
                                                  message: error.localizedDescription).napiValue(env)).throwIfError()
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
