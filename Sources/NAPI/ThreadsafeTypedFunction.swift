import NAPIC

public class ThreadsafeTypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible, P9: ValueConvertible {
    public typealias InternalFunction = TypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9>

    class CallbackData {
        typealias Continuation = CheckedContinuation<ValueConvertible, Swift.Error>
        typealias ResultConstructor = (napi_env, napi_value) throws -> ValueConvertible
        let this: ValueConvertible
        let args: [ValueConvertible]
        let continuation: Continuation
        let resultConstructor: ResultConstructor

        init(this: ValueConvertible, args: [ValueConvertible], continuation: Continuation) {
            self.this = this
            self.args = args
            self.continuation = continuation
            resultConstructor = { env, val in try Result(env, from: val) }
        }

        init(this: ValueConvertible, args: [ValueConvertible], continuation: Continuation) where Result == Undefined {
            self.this = this
            self.args = args
            self.continuation = continuation
            resultConstructor = { _, _ in Undefined.default }
        }
    }

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

private extension ThreadsafeTypedFunction {
    func _call(this: ValueConvertible, args: [ValueConvertible]) async throws where Result == Undefined {
        try napi_acquire_threadsafe_function(tsfn).throwIfError()
        defer { napi_release_threadsafe_function(tsfn, napi_tsfn_release) }

        _ = try await withCheckedThrowingContinuation { continuation in
            let unmanagedData = Unmanaged.passRetained(CallbackData(this: this, args: args, continuation: continuation))
            napi_call_threadsafe_function(tsfn, unmanagedData.toOpaque(), napi_tsfn_nonblocking)
        }
    }

    func _call(this: ValueConvertible, args: [ValueConvertible]) async throws -> Result {
        try napi_acquire_threadsafe_function(tsfn).throwIfError()
        defer { napi_release_threadsafe_function(tsfn, napi_tsfn_release) }

        return try await withCheckedThrowingContinuation { continuation in
            let unmanagedData = Unmanaged.passRetained(CallbackData(this: this, args: args, continuation: continuation))
            napi_call_threadsafe_function(tsfn, unmanagedData.toOpaque(), napi_tsfn_nonblocking)
        } as! Result
    }
}

public class ThreadsafeTypedFunction0<Result>: ThreadsafeTypedFunction<Result, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction0<Result>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call() async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [])
    }

    public func call() async throws -> Result {
        try await _call(this: Undefined.default, args: [])
    }
}

public class ThreadsafeTypedFunction1<Result, P0>: ThreadsafeTypedFunction<Result, P0, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction1<Result, P0>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call(_ p0: P0) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0])
    }

    public func call(_ p0: P0) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0])
    }
}

public class ThreadsafeTypedFunction2<Result, P0, P1>: ThreadsafeTypedFunction<Result, P0, P1, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction2<Result, P0, P1>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call(_ p0: P0, _ p1: P1) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0, p1])
    }

    public func call(_ p0: P0, _ p1: P1) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0, p1])
    }
}

public class ThreadsafeTypedFunction3<Result, P0, P1, P2>: ThreadsafeTypedFunction<Result, P0, P1, P2, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction3<Result, P0, P1, P2>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0, p1, p2])
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0, p1, p2])
    }
}

public class ThreadsafeTypedFunction4<Result, P0, P1, P2, P3>: ThreadsafeTypedFunction<Result, P0, P1, P2, P3, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction4<Result, P0, P1, P2, P3>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3])
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3])
    }
}

public class ThreadsafeTypedFunction5<Result, P0, P1, P2, P3, P4>: ThreadsafeTypedFunction<Result, P0, P1, P2, P3, P4, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction5<Result, P0, P1, P2, P3, P4>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4])
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4])
    }
}

public class ThreadsafeTypedFunction6<Result, P0, P1, P2, P3, P4, P5>: ThreadsafeTypedFunction<Result, P0, P1, P2, P3, P4, P5, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction6<Result, P0, P1, P2, P3, P4, P5>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5])
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5])
    }
}

public class ThreadsafeTypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>: ThreadsafeTypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6])
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6])
    }
}

public class ThreadsafeTypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>: ThreadsafeTypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7])
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7])
    }
}

public class ThreadsafeTypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>: ThreadsafeTypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
    public typealias ShortInternalFunction = TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>
    public init(_ env: napi_env, _ function: ShortInternalFunction) throws {
        try super.init(env, function)
    }

    public required convenience init(_ env: napi_env, from: napi_value) throws {
        let function = try ShortInternalFunction(env, from: from)
        try self.init(env, function)
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8])
    }

    public func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8])
    }
}

public typealias ThreadsafeTypedFunction10 = ThreadsafeTypedFunction

public extension ThreadsafeTypedFunction10 {
    func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9) async throws where Result == Undefined {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9])
    }

    func call(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9) async throws -> Result {
        try await _call(this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9])
    }
}
