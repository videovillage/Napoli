import NAPIC

public class TypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible, P9: ValueConvertible {
    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedClosure)
    }

    public typealias TypedArgs = (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9)
    public typealias TypedClosure = (napi_env, TypedArgs) throws -> Result
    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    fileprivate init(named name: String, _ callback: @escaping TypedClosure) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try createFunction(env, named: name) { env, args in
                try callback(env, Self.resolveArgs(env, args: args))
            }
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

private extension TypedFunction {
    func _call(_ env: napi_env, this: ValueConvertible, args: [ValueConvertible]) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try args.map { try $0.napiValue(env) }

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    func _call(_ env: napi_env, this: ValueConvertible, args: [ValueConvertible]) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try args.map { try $0.napiValue(env) }

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }
}

public class TypedFunction0<Result>: TypedFunction<Result, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible {
    public typealias Callback = () throws -> Result
    public typealias VoidCallback = () throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { (_: napi_env, _: TypedArgs) -> Result in
            try callback()
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { (_: napi_env, _: TypedArgs) in
            try callback()
            return Undefined.default
        }
    }

    public func call(_ env: napi_env) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [])
    }

    public func call(_ env: napi_env) throws -> Result {
        try _call(env, this: Undefined.default, args: [])
    }
}

public class TypedFunction1<Result, P0>: TypedFunction<Result, P0, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible {
    public typealias Callback = (P0) throws -> Result
    public typealias VoidCallback = (P0) throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { _, args in
            try callback(args.0)
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { _, args in
            try callback(args.0)
            return Undefined.default
        }
    }

    public func call(_ env: napi_env, _ p0: P0) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0])
    }

    public func call(_ env: napi_env, _ p0: P0) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0])
    }
}

public class TypedFunction2<Result, P0, P1>: TypedFunction<Result, P0, P1, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
    public typealias Callback = (P0, P1) throws -> Result
    public typealias VoidCallback = (P0, P1) throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { _, args in
            try callback(args.0, args.1)
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { _, args in
            try callback(args.0, args.1)
            return Undefined.default
        }
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1])
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1])
    }
}

public class TypedFunction3<Result, P0, P1, P2>: TypedFunction<Result, P0, P1, P2, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
    public typealias Callback = (P0, P1, P2) throws -> Result
    public typealias VoidCallback = (P0, P1, P2) throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2)
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2)
            return Undefined.default
        }
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1, p2])
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1, p2])
    }
}

public class TypedFunction4<Result, P0, P1, P2, P3>: TypedFunction<Result, P0, P1, P2, P3, Undefined, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
    public typealias Callback = (P0, P1, P2, P3) throws -> Result
    public typealias VoidCallback = (P0, P1, P2, P3) throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3)
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3)
            return Undefined.default
        }
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3])
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3])
    }
}

public class TypedFunction5<Result, P0, P1, P2, P3, P4>: TypedFunction<Result, P0, P1, P2, P3, P4, Undefined, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
    public typealias Callback = (P0, P1, P2, P3, P4) throws -> Result
    public typealias VoidCallback = (P0, P1, P2, P3, P4) throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4)
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4)
            return Undefined.default
        }
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4])
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4])
    }
}

public class TypedFunction6<Result, P0, P1, P2, P3, P4, P5>: TypedFunction<Result, P0, P1, P2, P3, P4, P5, Undefined, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
    public typealias Callback = (P0, P1, P2, P3, P4, P5) throws -> Result
    public typealias VoidCallback = (P0, P1, P2, P3, P4, P5) throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5)
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5)
            return Undefined.default
        }
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5])
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5])
    }
}

public class TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>: TypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, Undefined, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
    public typealias Callback = (P0, P1, P2, P3, P4, P5, P6) throws -> Result
    public typealias VoidCallback = (P0, P1, P2, P3, P4, P5, P6) throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5, args.6)
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5, args.6)
            return Undefined.default
        }
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6])
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6])
    }
}

public class TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>: TypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, Undefined, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
    public typealias Callback = (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result
    public typealias VoidCallback = (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5, args.6, args.7)
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5, args.6, args.7)
            return Undefined.default
        }
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7])
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7])
    }
}

public class TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>: TypedFunction<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8, Undefined> where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
    public typealias Callback = (P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Result
    public typealias VoidCallback = (P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Void

    public required init(_ env: napi_env, from: napi_value) throws {
        try super.init(env, from: from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5, args.6, args.7, args.8)
        }
    }

    public init(named name: String, _ callback: @escaping VoidCallback) where Result == Undefined {
        super.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5, args.6, args.7, args.8)
            return Undefined.default
        }
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8])
    }

    public func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8])
    }
}

public typealias TypedFunction10 = TypedFunction

public extension TypedFunction10 {
    typealias Callback10 = (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9) throws -> Result
    typealias VoidCallback10 = (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9) throws -> Void

    convenience init(named name: String, _ callback: @escaping Callback10) {
        self.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5, args.6, args.7, args.8, args.9)
        }
    }

    convenience init(named name: String, _ callback: @escaping VoidCallback10) where Result == Undefined {
        self.init(named: name) { _, args in
            try callback(args.0, args.1, args.2, args.3, args.4, args.5, args.6, args.7, args.8, args.9)
            return Undefined.default
        }
    }

    func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9) throws where Result == Undefined {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9])
    }

    func call(_ env: napi_env, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9) throws -> Result {
        try _call(env, this: Undefined.default, args: [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9])
    }
}
