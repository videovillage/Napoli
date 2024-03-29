import NAPIC

public typealias TypedFunctionCallback = (Environment, napi_value, [napi_value]) throws -> ValueConvertible

class TypedFunctionCallbackData {
    let callback: TypedFunctionCallback
    let argCount: Int

    init(callback: @escaping TypedFunctionCallback, argCount: Int) {
        self.callback = callback
        self.argCount = argCount
    }
}

func typedFuncNAPIFinalize(_: napi_env?, _ data: UnsafeMutableRawPointer!, _: UnsafeMutableRawPointer?) {
    Unmanaged<TypedFunctionCallbackData>.fromOpaque(data).release()
}

func typedFuncNAPICallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
    let env = Environment(env)
    enum Error: ErrorConvertible {
        case invalidArgCount(actual: Int, expected: Int)

        var message: String {
            switch self {
            case let .invalidArgCount(actual, expected):
                return "Received invalid arg count (actual: \(actual), expected: \(expected))"
            }
        }

        var code: String? {
            "ESWIFTCALLBACK"
        }
    }

    var this: napi_value!
    let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)
    napi_get_cb_info(env.env, cbinfo, nil, nil, &this, dataPointer)
    let data = Unmanaged<TypedFunctionCallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

    let usedArgs: [napi_value]
    var actualArgCount = data.argCount
    if data.argCount > 0 {
        var args = [napi_value?](repeating: nil, count: data.argCount)

        args.withUnsafeMutableBufferPointer {
            _ = napi_get_cb_info(env.env, cbinfo, &actualArgCount, $0.baseAddress, nil, nil)
        }

        usedArgs = args.map { $0! }
    } else {
        usedArgs = []
    }

    do {
        guard actualArgCount == data.argCount else {
            throw Error.invalidArgCount(actual: actualArgCount, expected: data.argCount)
        }

        return try data.callback(env, this, usedArgs).napiValue(env)
    } catch NAPIError.pendingException {
        return nil
    } catch {
        if !env.exceptionIsPending() { error.throwInJS(env) }
        return nil
    }
}

/// A type-erased typed function
public protocol Function: ValueConvertible {}

/// A mostly type-erased typed function with a typed `Result`
public protocol TypedResultFunction: Function {
    associatedtype Result: ValueConvertible
}

/// A type-safe function with return type `Result` and 9 parameters.
public class TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>: TypedResultFunction where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = (P0, P1, P2, P3, P4, P5, P6, P7, P8) async throws -> R
    public typealias AsyncConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5, P6, P7, P8) async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment, P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment, P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7]); let p8 = try P8(env, from: args[8])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4, p5, p6, p7, p8)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7]); let p8 = try P8(env, from: args[8])
            return VoidPromise {
                try await callback(p0, p1, p2, p3, p4, p5, p6, p7, p8)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]), P8(env, from: args[8]))
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env), p7.napiValue(env), p8.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env), p7.napiValue(env), p8.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 9)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}

/// A type-safe function with return type `Result` and 8 parameters.
public class TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>: TypedResultFunction where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> R
    public typealias AsyncConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4, p5, p6, p7)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6]); let p7 = try P7(env, from: args[7])
            return VoidPromise {
                try await callback(p0, p1, p2, p3, p4, p5, p6, p7)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]), P7(env, from: args[7]))
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env), p7.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env), p7.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 8)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}

/// A type-safe function with return type `Result` and 7 parameters.
public class TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>: TypedResultFunction where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4, P5, P6) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5, P6) throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = (P0, P1, P2, P3, P4, P5, P6) async throws -> R
    public typealias AsyncConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5, P6) async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4, p5, p6)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5]); let p6 = try P6(env, from: args[6])
            return VoidPromise {
                try await callback(p0, p1, p2, p3, p4, p5, p6)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]), P6(env, from: args[6]))
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 7)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}

/// A type-safe function with return type `Result` and 6 parameters.
public class TypedFunction6<Result, P0, P1, P2, P3, P4, P5>: TypedResultFunction where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4, P5) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5) throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = (P0, P1, P2, P3, P4, P5) async throws -> R
    public typealias AsyncConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5) async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment, P0, P1, P2, P3, P4, P5) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment, P0, P1, P2, P3, P4, P5) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4, p5)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4]); let p5 = try P5(env, from: args[5])
            return VoidPromise {
                try await callback(p0, p1, p2, p3, p4, p5)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]), P5(env, from: args[5]))
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 6)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}

/// A type-safe function with return type `Result` and 5 parameters.
public class TypedFunction5<Result, P0, P1, P2, P3, P4>: TypedResultFunction where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4) throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = (P0, P1, P2, P3, P4) async throws -> R
    public typealias AsyncConvenienceVoidCallback = (P0, P1, P2, P3, P4) async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment, P0, P1, P2, P3, P4) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment, P0, P1, P2, P3, P4) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4])
            return Promise<R> {
                try await callback(p0, p1, p2, p3, p4)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3]); let p4 = try P4(env, from: args[4])
            return VoidPromise {
                try await callback(p0, p1, p2, p3, p4)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]), P4(env, from: args[4]))
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 5)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}

/// A type-safe function with return type `Result` and 4 parameters.
public class TypedFunction4<Result, P0, P1, P2, P3>: TypedResultFunction where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3) throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = (P0, P1, P2, P3) async throws -> R
    public typealias AsyncConvenienceVoidCallback = (P0, P1, P2, P3) async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment, P0, P1, P2, P3) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment, P0, P1, P2, P3) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3])
            return Promise<R> {
                try await callback(p0, p1, p2, p3)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2]); let p3 = try P3(env, from: args[3])
            return VoidPromise {
                try await callback(p0, p1, p2, p3)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]), P3(env, from: args[3]))
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 4)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}

/// A type-safe function with return type `Result` and 3 parameters.
public class TypedFunction3<Result, P0, P1, P2>: TypedResultFunction where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2) throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = (P0, P1, P2) async throws -> R
    public typealias AsyncConvenienceVoidCallback = (P0, P1, P2) async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment, P0, P1, P2) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment, P0, P1, P2) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2])
            return Promise<R> {
                try await callback(p0, p1, p2)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1]); let p2 = try P2(env, from: args[2])
            return VoidPromise {
                try await callback(p0, p1, p2)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]), P2(env, from: args[2]))
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 3)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}

/// A type-safe function with return type `Result` and 2 parameters.
public class TypedFunction2<Result, P0, P1>: TypedResultFunction where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1) throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = (P0, P1) async throws -> R
    public typealias AsyncConvenienceVoidCallback = (P0, P1) async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment, P0, P1) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment, P0, P1) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]), P1(env, from: args[1]))
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1])
            return Promise<R> {
                try await callback(p0, p1)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0]); let p1 = try P1(env, from: args[1])
            return VoidPromise {
                try await callback(p0, p1)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]), P1(env, from: args[1]))
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 2)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}

/// A type-safe function with return type `Result` and 1 parameter.
public class TypedFunction1<Result, P0>: TypedResultFunction where Result: ValueConvertible, P0: ValueConvertible {
    public typealias ConvenienceCallback = (P0) throws -> Result
    public typealias ConvenienceVoidCallback = (P0) throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = (P0) async throws -> R
    public typealias AsyncConvenienceVoidCallback = (P0) async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment, P0) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment, P0) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(P0(env, from: args[0]))
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0])
            return Promise<R> {
                try await callback(p0)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { env, _, args in
            let p0 = try P0(env, from: args[0])
            return VoidPromise {
                try await callback(p0)
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]))
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, args in
            try callback(env, P0(env, from: args[0]))
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default, _ p0: P0) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 1)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}

/// A type-safe function with return type `Result`.
public class TypedFunction0<Result>: TypedResultFunction where Result: ValueConvertible {
    public typealias ConvenienceCallback = () throws -> Result
    public typealias ConvenienceVoidCallback = () throws -> Void
    public typealias AsyncConvenienceCallback<R: ValueConvertible> = () async throws -> R
    public typealias AsyncConvenienceVoidCallback = () async throws -> Void

    public typealias ConvenienceEnvCallback = (Environment) throws -> Result
    public typealias ConvenienceEnvVoidCallback = (Environment) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: Environment, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
        self.init(named: name) { _, _, _ in
            try callback()
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
        self.init(named: name) { _, _, _ in
            try callback()
            return Undefined.default
        }
    }

    public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
        self.init(named: name) { _, _, _ in

            Promise<R> {
                try await callback()
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == VoidPromise {
        self.init(named: name) { _, _, _ in

            VoidPromise {
                try await callback()
            }
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvCallback) {
        self.init(named: name) { env, _, _ in
            try callback(env)
        }
    }

    public convenience init(named name: String, _ callback: @escaping ConvenienceEnvVoidCallback) where Result == Undefined {
        self.init(named: name) { env, _, _ in
            try callback(env)
            return Undefined.default
        }
    }

    public func napiValue(_ env: Environment) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = []

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: Environment, this: ValueConvertible = Undefined.default) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = []

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env.env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: Environment, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 0)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env.env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, typedFuncNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        try napi_add_finalizer(env.env, result!, unmanagedData.toOpaque(), typedFuncNAPIFinalize, nil, nil).throwIfError()

        return result!
    }
}
