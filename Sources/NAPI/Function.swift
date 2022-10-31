import NAPIC

func createFunction(_ env: napi_env, named name: String, _ function: @escaping Callback) throws -> napi_value {
    var result: napi_value?
    let nameData = name.data(using: .utf8)!

    let data = CallbackData(callback: function)
    let unmanagedData = Unmanaged.passRetained(data)

    do {
        try nameData.withUnsafeBytes {
            napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, swiftNAPICallback, unmanagedData.toOpaque(), &result)
        }.throwIfError()
    } catch {
        unmanagedData.release()
        throw error
    }

    return result!
}

private enum InternalFunction {
    case javascript(napi_value)
    case swift(String, Callback)
//    case swiftAsync(String, AsyncCallback)
}

public class Function: ValueConvertible {
    fileprivate let value: InternalFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        value = .swift(name, callback)
    }

//    public init(named name: String, _ callback: @escaping AsyncCallback) {
//        value = .swiftAsync(name, callback)
//    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback): return try createFunction(env, named: name, callback)
//        case let .swiftAsync(name, callback): return try createFunction(env, named: name, { env, args in return try callAsyncFunction(env, args: args, callback) })
        case let .javascript(value): return value
        }
    }
}

/* constructor overloads */
public extension Function {
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
public extension Function {
    private func _call(_ env: napi_env, this: napi_value, args: [napi_value?]) throws {
        let handle = try napiValue(env)

        try args.withUnsafeBufferPointer { argsBytes in
            napi_call_function(env, this, handle, args.count, argsBytes.baseAddress, nil)
        }.throwIfError()
    }

    private func _call<Result: ValueConvertible>(_ env: napi_env, this: napi_value, args: [napi_value?]) throws -> Result {
        let handle = try napiValue(env)

        var result: napi_value?
        try args.withUnsafeBufferPointer { argsBytes in
            napi_call_function(env, this, handle, args.count, argsBytes.baseAddress, &result)
        }.throwIfError()

        return try Result(env, from: result!)
    }

    /* (...) -> Void */

    func call(_ env: napi_env) throws {
        try _call(env, this: Value.undefined.napiValue(env), args: [])
    }

    func call(_ env: napi_env, _ a: some ValueConvertible) throws {
        try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env)])
    }

    func call(_ env: napi_env, _ a: some ValueConvertible, _ b: some ValueConvertible) throws {
        try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env), b.napiValue(env)])
    }

    /* (...) -> ValueConvertible */

    func call<Result: ValueConvertible>(_ env: napi_env) throws -> Result {
        try _call(env, this: Value.undefined.napiValue(env), args: [])
    }

    func call<Result: ValueConvertible>(_ env: napi_env, _ a: some ValueConvertible) throws -> Result {
        try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env)])
    }

    func call<Result: ValueConvertible>(_ env: napi_env, _ a: some ValueConvertible, _ b: some ValueConvertible) throws -> Result {
        try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env), b.napiValue(env)])
    }
}
