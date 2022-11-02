import NAPIC

class ThreadsafeFunctionCallbackData {
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

func newNAPIThreadsafeFinalize(_: napi_env!, pointer _: UnsafeMutableRawPointer?, hint _: UnsafeMutableRawPointer?) {}

func newNAPIThreadsafeCallback(_ env: napi_env?, _ js_callback: napi_value?, _: UnsafeMutableRawPointer?, _ data: UnsafeMutableRawPointer!) {
    let callbackData = Unmanaged<ThreadsafeFunctionCallbackData>.fromOpaque(data).takeRetainedValue()

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
            if try! exceptionIsPending(env) {
                var errorResult: napi_value!
                try! napi_get_and_clear_last_exception(env, &errorResult).throwIfError()
                callbackData.continuation.resume(throwing: JSException(value: errorResult))
            } else {
                callbackData.continuation.resume(throwing: error)
            }
        }
    }
}

private func _call(tsfn: napi_threadsafe_function, this: ValueConvertible, args: [ValueConvertible]) async throws {
    try napi_acquire_threadsafe_function(tsfn).throwIfError()
    defer { napi_release_threadsafe_function(tsfn, napi_tsfn_release) }

    _ = try await withCheckedThrowingContinuation { continuation in
        let unmanagedData = Unmanaged.passRetained(ThreadsafeFunctionCallbackData(this: this, args: args, continuation: continuation))
        napi_call_threadsafe_function(tsfn, unmanagedData.toOpaque(), napi_tsfn_nonblocking)
    }
}

private func _call<Result: ValueConvertible>(tsfn: napi_threadsafe_function, this: ValueConvertible, args: [ValueConvertible], resultType: Result.Type) async throws -> Result {
    try napi_acquire_threadsafe_function(tsfn).throwIfError()
    defer { napi_release_threadsafe_function(tsfn, napi_tsfn_release) }

    return try await withCheckedThrowingContinuation { continuation in
        let unmanagedData = Unmanaged.passRetained(ThreadsafeFunctionCallbackData(this: this, args: args, continuation: continuation, resultType: resultType))
        napi_call_threadsafe_function(tsfn, unmanagedData.toOpaque(), napi_tsfn_nonblocking)
    } as! Result
}

public class NewThreadsafeTypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8])
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

public class NewThreadsafeTypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4, p5, p6, p7])
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4, p5, p6, p7], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

public class NewThreadsafeTypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4, p5, p6])
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4, p5, p6], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

public class NewThreadsafeTypedFunction6<Result, P0, P1, P2, P3, P4, P5>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction6<Result, P0, P1, P2, P3, P4, P5>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4, p5])
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4, p5], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

public class NewThreadsafeTypedFunction5<Result, P0, P1, P2, P3, P4>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction5<Result, P0, P1, P2, P3, P4>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4])
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3, p4], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

public class NewThreadsafeTypedFunction4<Result, P0, P1, P2, P3>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction4<Result, P0, P1, P2, P3>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3])
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2, p3], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

public class NewThreadsafeTypedFunction3<Result, P0, P1, P2>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction3<Result, P0, P1, P2>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2])
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1, p2], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

public class NewThreadsafeTypedFunction2<Result, P0, P1>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction2<Result, P0, P1>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1])
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [p0, p1], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

public class NewThreadsafeTypedFunction1<Result, P0>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction1<Result, P0>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [p0])
    }

    public func call(this: ValueConvertible = Undefined.default, _ p0: P0) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [p0], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}

public class NewThreadsafeTypedFunction0<Result>: ValueConvertible where Result: ValueConvertible {
    public typealias InternalFunction = NewTypedFunction0<Result>
    fileprivate var tsfn: napi_threadsafe_function!

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try InternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try Undefined.default.napiValue(env)
    }

    public init(_ env: napi_env, _ function: InternalFunction) throws {
        try napi_create_threadsafe_function(env,
                                            function.napiValue(env),
                                            nil,
                                            "ThreadsafeWrapper".napiValue(env),
                                            0,
                                            1,
                                            nil,
                                            newNAPIThreadsafeFinalize,
                                            nil,
                                            newNAPIThreadsafeCallback,
                                            &tsfn).throwIfError()
    }

    public func call(this: ValueConvertible = Undefined.default) async throws where Result == Undefined {
        try await _call(tsfn: tsfn, this: this, args: [])
    }

    public func call(this: ValueConvertible = Undefined.default) async throws -> Result {
        try await _call(tsfn: tsfn, this: this, args: [], resultType: Result.self)
    }

    deinit {
        if let tsfn {
            napi_release_threadsafe_function(tsfn, napi_tsfn_release)
        }
    }
}
