import Foundation
import NAPIC

public class ThreadsafeFunction {
    fileprivate class CallbackData {
        typealias Continuation = CheckedContinuation<ValueConvertible, Swift.Error>
        typealias ResultConstructor = (napi_env, napi_value) throws -> ValueConvertible
        let this: ValueConvertible
        let args: [ValueConvertible]
        let continuation: Continuation
        let resultConstructor: ResultConstructor

        init<Result: ValueConvertible>(this: ValueConvertible, args: [ValueConvertible], continuation: Continuation, resultType: Result.Type) {
            self.this = this
            self.args = args
            self.continuation = continuation
            self.resultConstructor = { env, val in try Result(env, from: val) }
        }

        init(this: ValueConvertible, args: [ValueConvertible], continuation: Continuation) {
            self.this = this
            self.args = args
            self.continuation = continuation
            self.resultConstructor = { _, _ in Value.undefined }
        }
    }

    private let id = UUID().uuidString
    fileprivate var tsfn: napi_threadsafe_function! = nil

    public init(_ env: napi_env, _ function: Function) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            Value.string("ThreadsafeWrapper\(id)").napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            swiftNAPIThreadsafeFinalize,
                                            nil,
                                            swiftNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
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

func swiftNAPIThreadsafeFinalize(_: napi_env!, pointer: UnsafeMutableRawPointer?, hint _: UnsafeMutableRawPointer?) {
    
}

func swiftNAPIThreadsafeCallback(_ env: napi_env?, _ js_callback: napi_value?, _ context: UnsafeMutableRawPointer?, _ data: UnsafeMutableRawPointer!) {
    let callbackData = Unmanaged<ThreadsafeFunction.CallbackData>.fromOpaque(data).takeRetainedValue()

    var result: napi_value?

    if let env {
        do {
            let this = try callbackData.this.napiValue(env)
            let args: [napi_value?] = try callbackData.args.map { try $0.napiValue(env) }
            try args.withUnsafeBufferPointer { argsBytes in
                napi_call_function(env, this, js_callback, args.count, argsBytes.baseAddress, &result)
            }.throwIfError()
            try callbackData.continuation.resume(returning: callbackData.resultConstructor(env, result!))
        } catch {
            callbackData.continuation.resume(throwing: error)
        }
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
        try await _call(this: Value.undefined, args: [])
    }

    func call<A: ValueConvertible>(_ a: A) async throws -> Void {
        try await _call(this: Value.undefined, args: [a])
    }

    func call<A: ValueConvertible, B: ValueConvertible>(_ a: A, _ b: B) async throws -> Void {
        try await _call(this: Value.undefined, args: [a, b])
    }

//    /* (...) -> ValueConvertible */

    func call<Result: ValueConvertible>() async throws -> Result {
        try await _call(this: Value.undefined, args: [])
    }

    func call<Result: ValueConvertible, A: ValueConvertible>(_ a: A) async throws -> Result {
        try await _call(this: Value.undefined, args: [a])
    }

    func call<Result: ValueConvertible, A: ValueConvertible, B: ValueConvertible>(_ a: A, _ b: B) async throws -> Result {
        try await _call(this: Value.undefined, args: [a, b])
    }
}
