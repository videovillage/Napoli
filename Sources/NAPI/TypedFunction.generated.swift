import NAPIC

public typealias TypedFunctionCallback = (napi_env, napi_value, [napi_value]) throws -> ValueConvertible

private class TypedFunctionCallbackData {
    let callback: TypedFunctionCallback
    let argCount: Int

    init(callback: @escaping TypedFunctionCallback, argCount: Int) {
        self.callback = callback
        self.argCount = argCount
    }
}

func newNAPICallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
    var this: napi_value!
    let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)
    napi_get_cb_info(env, cbinfo, nil, nil, &this, dataPointer)
    let data = Unmanaged<TypedFunctionCallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

    let usedArgs: [napi_value]
    if data.argCount > 0 {
        var args = [napi_value?](repeating: nil, count: data.argCount)
        var argCount = data.argCount

        args.withUnsafeMutableBufferPointer {
            _ = napi_get_cb_info(env, cbinfo, &argCount, $0.baseAddress, nil, nil)
        }

        assert(argCount == data.argCount)
        usedArgs = args.map { $0! }
    } else {
        usedArgs = []
    }

    do {
        return try data.callback(env, this, usedArgs).napiValue(env)
    } catch NAPI.Error.pendingException {
        return nil
    } catch {
        if try! exceptionIsPending(env) == false { try! throwError(env, error) }
        return nil
    }
}

public class TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5, P6, P7, P8) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env), p7.napiValue(env), p8.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env), p7.napiValue(env), p8.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 9)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}

public class TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env), p7.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env), p7.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 8)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}

public class TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4, P5, P6) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5, P6) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env), p6.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 7)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}

public class TypedFunction6<Result, P0, P1, P2, P3, P4, P5>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4, P5) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4, P5) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env), p5.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 6)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}

public class TypedFunction5<Result, P0, P1, P2, P3, P4>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3, P4) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3, P4) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env), p4.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 5)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}

public class TypedFunction4<Result, P0, P1, P2, P3>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2, P3) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2, P3) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env), p3.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 4)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}

public class TypedFunction3<Result, P0, P1, P2>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1, P2) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1, P2) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1, _ p2: P2) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env), p2.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 3)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}

public class TypedFunction2<Result, P0, P1>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
    public typealias ConvenienceCallback = (P0, P1) throws -> Result
    public typealias ConvenienceVoidCallback = (P0, P1) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0, _ p1: P1) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env), p1.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 2)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}

public class TypedFunction1<Result, P0>: ValueConvertible where Result: ValueConvertible, P0: ValueConvertible {
    public typealias ConvenienceCallback = (P0) throws -> Result
    public typealias ConvenienceVoidCallback = (P0) throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env)]

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default, _ p0: P0) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = try [p0.napiValue(env)]

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 1)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}

public class TypedFunction0<Result>: ValueConvertible where Result: ValueConvertible {
    public typealias ConvenienceCallback = () throws -> Result
    public typealias ConvenienceVoidCallback = () throws -> Void

    fileprivate enum InternalTypedFunction {
        case javascript(napi_value)
        case swift(String, TypedFunctionCallback)
    }

    fileprivate let value: InternalTypedFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback):
            return try Self.createFunction(env, named: name) { env, this, args in
                try callback(env, this, args)
            }
        case let .javascript(value):
            return value
        }
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default) throws where Result == Undefined {
        let handle = try napiValue(env)

        let args: [napi_value?] = []

        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    public func call(_ env: napi_env, this: ValueConvertible = Undefined.default) throws -> Result {
        let handle = try napiValue(env)

        let args: [napi_value?] = []

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
        var result: napi_value?
        let nameData = name.data(using: .utf8)!

        let data = TypedFunctionCallbackData(callback: callback, argCount: 0)
        let unmanagedData = Unmanaged.passRetained(data)

        do {
            try nameData.withUnsafeBytes {
                napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback, unmanagedData.toOpaque(), &result)
            }.throwIfError()
        } catch {
            unmanagedData.release()
            throw error
        }

        return result!
    }
}
