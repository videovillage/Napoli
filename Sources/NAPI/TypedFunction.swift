import NAPIC

public class TypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible, P9: ValueConvertible {
    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedCallback)
    }

    public typealias TypedArgs = (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9)
    public typealias TypedCallback = (napi_env, TypedArgs) throws -> Result
    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    fileprivate init(named name: String, _ callback: @escaping TypedCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try createFunction(env, named: name) { env, args in
                try callback(env, Self.resolveArgs(env, args: args))
            }
//        case let .swiftAsync(name, callback): return try createFunction(env, named: name, { env, args in return try callAsyncFunction(env, args: args, callback) })
        case let .javascript(value):
            return value
        }
    }

    public static func resolveArgs(_ env: napi_env, args: Arguments) throws -> TypedArgs {
        try (P0(env, from: args.0),
             P1(env, from: args.1),
             P2(env, from: args.2),
             P3(env, from: args.3),
             P4(env, from: args.4),
             P5(env, from: args.5),
             P6(env, from: args.6),
             P7(env, from: args.7),
             P8(env, from: args.8),
             P9(env, from: args.9))
    }
}

public typealias TypedFunction0<Result> = TypedFunction<Result, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible

public typealias TypedFunction1<Result, P0> = TypedFunction<Result, P0, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible

public typealias TypedFunction2<Result, P0, P1> = TypedFunction<Result, P0, P1, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible

public typealias TypedFunction3<Result, P0, P1, P2> = TypedFunction<Result, P0, P1, P2, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible

public typealias TypedFunction4<Result, P0, P1, P2, P3> = TypedFunction<Result, P0, P1, P2, P3, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible

public typealias TypedFunction5<Result, P0, P1, P2, P3, P4> = TypedFunction<Result, P0, P1, P2, P3, P4, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible

public typealias TypedFunction6<Result, P0, P1, P2, P3, P4, P5> = TypedFunction<Result, P0, P1, P2, P3, P4, P5, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible

public typealias TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6> = TypedFunction<Result, P0, P0, P1, P2, P3, P4, P5, P6, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible

public typealias TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7> = TypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible

public typealias TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8> = TypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible

public typealias TypedFunction10 = TypedFunction

extension TypedFunction {
    private func _call(_ env: napi_env, this: ValueConvertible, args: [ValueConvertible]) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try args.map { try $0.napiValue(env) }

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    private func _call(_ env: napi_env, this: ValueConvertible, args: [ValueConvertible]) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try args.map { try $0.napiValue(env) }

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }
}

public extension TypedFunction0 {
    typealias Callback0 = () throws -> Result
    typealias VoidCallback0 = () throws -> Void

    convenience init(named name: String, _ callback: @escaping Callback0) {
        self.init(named: name) { (_: napi_env, _: TypedArgs) -> Result in
            try callback()
        }
    }

    convenience init(named name: String, _ callback: @escaping VoidCallback0) where Result == Undefined {
        self.init(named: name) { (_: napi_env, _: TypedArgs) in
            try callback()
            return Undefined.default
        }
    }

    func call(_ env: napi_env) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [])
    }

    func call(_ env: napi_env) throws -> Result {
        try _call(env, this: Undefined.default, args: [])
    }
}

public extension TypedFunction1 {
    typealias Callback1 = (P0) throws -> Result
    typealias VoidCallback1 = (P0) throws -> Void
    convenience init(named name: String, _ callback: @escaping Callback1) {
        self.init(named: name) { _, args in
            try callback(args.0)
        }
    }

    convenience init(named name: String, _ callback: @escaping VoidCallback1) where Result == Undefined {
        self.init(named: name) { _, args in
            try callback(args.0)
            return Undefined.default
        }
    }

    func call(_ env: napi_env, _ p0: P0) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0])
    }

    func call(_ env: napi_env, _ p0: P0) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0])
    }
}

public extension TypedFunction2 {
    typealias Callback2 = (P0, P1) throws -> Result
    typealias VoidCallback2 = (P0, P1) throws -> Void
    convenience init(named name: String, _ callback: @escaping Callback2) {
        self.init(named: name) { _, args in
            try callback(args.0, args.1)
        }
    }

    convenience init(named name: String, _ callback: @escaping VoidCallback2) where Result == Undefined {
        self.init(named: name) { _, args in
            try callback(args.0, args.1)
            return Undefined.default
        }
    }

    func call(_ env: napi_env, _ p0: P0, _ p1: P1) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1])
    }

    func call(_ env: napi_env, _ p0: P0, _ p1: P1) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1])
    }
}
