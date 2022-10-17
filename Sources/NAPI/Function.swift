import NAPIC

private func createFunction(_ env: napi_env, named name: String, _ function: @escaping Callback) throws -> napi_value {
    var result: napi_value?
    let nameData = name.data(using: .utf8)!

    let data = CallbackData(callback: function)
    let dataPointer = Unmanaged.passRetained(data).toOpaque()

    let status = nameData.withUnsafeBytes { nameBytes in
        napi_create_function(env, nameBytes, nameData.count, swiftNAPICallback, dataPointer, &result)
    }

    guard status == napi_ok else { throw NAPI.Error(status) }

    return result!
}

private enum InternalFunction {
    case javascript(napi_value)
    case swift(String, Callback)
}

public class Function: ValueConvertible {
    fileprivate let value: InternalFunction

    public required init(_: napi_env, from: napi_value) throws {
        value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
        case let .swift(name, callback): return try createFunction(env, named: name, callback)
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

        let status = args.withUnsafeBufferPointer { argsBytes in
            napi_call_function(env, this, handle, args.count, argsBytes.baseAddress, nil)
        }

        guard status == napi_ok else { throw NAPI.Error(status) }
    }

    private func _call<Result: ValueConvertible>(_ env: napi_env, this: napi_value, args: [napi_value?]) throws -> Result {
        let handle = try napiValue(env)

        var result: napi_value?
        let status = args.withUnsafeBufferPointer { argsBytes in
            napi_call_function(env, this, handle, args.count, argsBytes.baseAddress, &result)
        }

        guard status == napi_ok else { throw NAPI.Error(status) }

        return try Result(env, from: result!)
    }

    /* (...) -> Void */

    func call(_ env: napi_env) throws {
        try _call(env, this: Value.undefined.napiValue(env), args: [])
    }

    func call<A: ValueConvertible>(_ env: napi_env, _ a: A) throws -> Void {
        try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env)])
    }

    func call<A: ValueConvertible, B: ValueConvertible>(_ env: napi_env, _ a: A, _ b: B) throws -> Void {
        try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env), b.napiValue(env)])
    }

    /* (...) -> ValueConvertible */

    func call<Result: ValueConvertible>(_ env: napi_env) throws -> Result {
        try _call(env, this: Value.undefined.napiValue(env), args: [])
    }

    func call<Result: ValueConvertible, A: ValueConvertible>(_ env: napi_env, _ a: A) throws -> Result {
        try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env)])
    }

    func call<Result: ValueConvertible, A: ValueConvertible, B: ValueConvertible>(_ env: napi_env, _ a: A, _ b: B) throws -> Result {
        try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env), b.napiValue(env)])
    }
}
