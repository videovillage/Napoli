import Foundation
import NAPIC

public class ThreadsafeFunction: ValueConvertible {
    class CallbackData {
        typealias Continuation = CheckedContinuation<ValueConvertible, Swift.Error>
        typealias ResultConstructor = (napi_env, napi_value) throws -> ValueConvertible
        let this: ValueConvertible
        let args: [ValueConvertible]
        let continuation: Continuation
        let resultConstructor: ResultConstructor

        init<Result: ValueConvertible>(this: ValueConvertible, args: [ValueConvertible], continuation: Continuation, resultType _: Result.Type) {
            self.this = this
            self.args = args
            self.continuation = continuation
            resultConstructor = { env, val in try Result(env, from: val) }
        }

        init(this: ValueConvertible, args: [ValueConvertible], continuation: Continuation) {
            self.this = this
            self.args = args
            self.continuation = continuation
            resultConstructor = { _, _ in Undefined.default }
        }
    }

    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try Function(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: Function) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            swiftNAPIThreadsafeFinalize,
                                            nil,
                                            swiftNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

private class ThreadsafeData {
    let this: napi_value
    let args: [napi_value?]

    init(this: napi_value, args: [napi_value?]) {
        self.this = this
        self.args = args
    }
}

/* call(...) */
public extension ThreadsafeFunction {
    private func _call(this: ValueConvertible, args: [ValueConvertible]) async throws {
        try napi_acquire_threadsafe_function(tsfn).throwIfError()
        defer { napi_release_threadsafe_function(tsfn, napi_tsfn_release) }

        _ = try await withCheckedThrowingContinuation { continuation in
            let unmanagedData = Unmanaged.passRetained(CallbackData(this: this, args: args, continuation: continuation))
            napi_call_threadsafe_function(tsfn, unmanagedData.toOpaque(), napi_tsfn_nonblocking)
        }
    }

    private func _call<Result: ValueConvertible>(this: ValueConvertible, args: [ValueConvertible]) async throws -> Result {
        try napi_acquire_threadsafe_function(tsfn).throwIfError()
        defer { napi_release_threadsafe_function(tsfn, napi_tsfn_release) }

        return try await withCheckedThrowingContinuation { continuation in
            let unmanagedData = Unmanaged.passRetained(CallbackData(this: this, args: args, continuation: continuation, resultType: Result.self))
            napi_call_threadsafe_function(tsfn, unmanagedData.toOpaque(), napi_tsfn_nonblocking)
        } as! Result
    }

//    /* (...) -> Void */

    func call() async throws {
        try await _call(this: Undefined.default, args: [])
    }

    func call(_ a: some ValueConvertible) async throws {
        try await _call(this: Undefined.default, args: [a])
    }

    func call(_ a: some ValueConvertible, _ b: some ValueConvertible) async throws {
        try await _call(this: Undefined.default, args: [a, b])
    }

//    /* (...) -> ValueConvertible */

    func call<Result: ValueConvertible>() async throws -> Result {
        try await _call(this: Undefined.default, args: [])
    }

    func call<Result: ValueConvertible>(_ a: some ValueConvertible) async throws -> Result {
        try await _call(this: Undefined.default, args: [a])
    }

    func call<Result: ValueConvertible>(_ a: some ValueConvertible, _ b: some ValueConvertible) async throws -> Result {
        try await _call(this: Undefined.default, args: [a, b])
    }
}