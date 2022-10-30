import Foundation
import NAPIC

public protocol ErrorConvertible: Swift.Error {
    var message: String { get }
    var code: String? { get }
}

private func throwError(_ env: napi_env, _ error: Swift.Error) throws {
    if let error = error as? NAPI.Error {
        try error.napi_throw(env).throwIfError()
    } else if let error = error as? ValueConvertible {
        try napi_throw(env, error.napiValue(env)).throwIfError()
    } else if let error = error as? ErrorConvertible {
        try napi_throw_error(env, error.code, error.message).throwIfError()
    } else {
        try napi_throw_error(env, nil, error.localizedDescription).throwIfError()
    }
}

private func exceptionIsPending(_ env: napi_env) throws -> Bool {
    var result = false

    try napi_is_exception_pending(env, &result).throwIfError()

    return result
}

public typealias AsyncCallback = (napi_env, Arguments) async throws -> ValueConvertible?
public typealias Callback = (napi_env, Arguments) throws -> ValueConvertible?

class CallbackData {
    let callback: Callback

    init(callback: @escaping Callback) {
        self.callback = callback
    }
}

class GetSetCallbackData {
    let getter: Callback
    let setter: Callback?

    init(getter: @escaping Callback, setter: Callback?) {
        self.getter = getter
        self.setter = setter
    }
}

func swiftNAPICallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
    var args = NullableArguments(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 10, nil)
    let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)

    napi_get_cb_info(env, cbinfo, &args.length, &args.0, &args.this, dataPointer)
    let data = Unmanaged<CallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

    do {
        return try data.callback(env, args as! Arguments)?.napiValue(env)
    } catch NAPI.Error.pendingException {
        return nil
    } catch {
        if try! exceptionIsPending(env) == false { try! throwError(env, error) }
        return nil
    }
}

func swiftNAPIGetterCallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
    var args = NullableArguments(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 10, nil)
    let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)

    napi_get_cb_info(env, cbinfo, &args.length, &args.0, &args.this, dataPointer)
    let data = Unmanaged<GetSetCallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

    do {
        return try data.getter(env, args as! Arguments)?.napiValue(env)
    } catch NAPI.Error.pendingException {
        return nil
    } catch {
        if try! exceptionIsPending(env) == false { try! throwError(env, error) }
        return nil
    }
}

func swiftNAPISetterCallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
    var args = NullableArguments(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 10, nil)
    let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)

    napi_get_cb_info(env, cbinfo, &args.length, &args.0, &args.this, dataPointer)
    let data = Unmanaged<GetSetCallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

    do {
        return try data.setter!(env, args as! Arguments)?.napiValue(env)
    } catch NAPI.Error.pendingException {
        return nil
    } catch {
        if try! exceptionIsPending(env) == false { try! throwError(env, error) }
        return nil
    }
}

func swiftNAPIThreadsafeFinalize(_: napi_env!, pointer _: UnsafeMutableRawPointer?, hint _: UnsafeMutableRawPointer?) {}

func swiftNAPIThreadsafeCallback(_ env: napi_env?, _ js_callback: napi_value?, _: UnsafeMutableRawPointer?, _ data: UnsafeMutableRawPointer!) {
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

public enum Value: ValueConvertible {
    case `class`(Class)
    case function(Function)
    case object([String: Value])
    case array([Value])
    case string(String)
    case number(Double)
    case boolean(Bool)
    case null
    case undefined

    public init(_: napi_env, from _: napi_value) throws {
        fatalError("Not implemented")
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch self {
        case let .class(`class`): return try `class`.napiValue(env)
        case let .function(function): return try function.napiValue(env)
        case let .object(object): return try object.napiValue(env)
        case let .array(array): return try array.napiValue(env)
        case let .string(string): return try string.napiValue(env)
        case let .number(number): return try number.napiValue(env)
        case let .boolean(boolean): return try boolean.napiValue(env)
        case .null: return try Null.default.napiValue(env)
        case .undefined: return try Undefined.default.napiValue(env)
        }
    }
}

extension Value: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let object = try? container.decode([String: Value].self) {
            self = .object(object)
        } else if let array = try? container.decode([Value].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if let boolean = try? container.decode(Bool.self) {
            self = .boolean(boolean)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Failed to decode value"))
        }
    }
}

extension Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case .class: return "[Function: ...]"
        case .function: return "[Function: ...]"
        case let .object(object): return "{ \(object.map { "\($0): \($1)" }.joined(separator: ", "))) }"
        case let .array(array): return "[ \(array.map { String(describing: $0) }.joined(separator: ", ")) ]"
        case let .string(string): return string
        case let .number(number): return String(describing: number)
        case let .boolean(boolean): return boolean ? "true" : "false"
        case .null: return "null"
        case .undefined: return "undefined"
        }
    }
}
