import Foundation
import NAPIC

public class ThreadsafeFunction: ValueConvertible {
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
    fileprivate let function: Function
    fileprivate var tsfn: napi_threadsafe_function! = nil

    public required init(_ env: napi_env, from: napi_value) throws {
        function = try Function(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        function = Function(named: name, callback)
    }

    public init(_ function: Function) {
        self.function = function
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        print("createThreadsafeFunction")
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            nil,
                                            0,
                                            1,
                                            nil,
                                            swiftNAPIThreadsafeFinalize,
                                            nil,
                                            swiftNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()

        return try Value.undefined.napiValue(env)
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

/* constructor overloads */
public extension ThreadsafeFunction {
    /* (...) -> Void */

    convenience init(named name: String, _ callback: @escaping () throws -> Void) {
        self.init(named: name) { _, _ in try callback(); return Value.undefined }
    }

    convenience init<A: ValueConvertible>(named name: String, _ callback: @escaping (A) throws -> Void) {
        self.init(named: name) { env, args in try callback(A(env, from: args.0)); return Value.undefined }
    }

    convenience init<A: ValueConvertible, B: ValueConvertible>(named name: String, _ callback: @escaping (A, B) throws -> Void) {
        self.init(named: name) { env, args in try callback(A(env, from: args.0), B(env, from: args.1)); return Value.undefined }
    }

    /* (env, ...) -> Void */

    convenience init(named name: String, _ callback: @escaping (napi_env) throws -> Void) {
        self.init(named: name) { env, _ in try callback(env); return Value.undefined }
    }

    convenience init<A: ValueConvertible>(named name: String, _ callback: @escaping (napi_env, A) throws -> Void) {
        self.init(named: name) { env, args in try callback(env, A(env, from: args.0)); return Value.undefined }
    }

    convenience init<A: ValueConvertible, B: ValueConvertible>(named name: String, _ callback: @escaping (napi_env, A, B) throws -> Void) {
        self.init(named: name) { env, args in try callback(env, A(env, from: args.0), B(env, from: args.1)); return Value.undefined }
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
