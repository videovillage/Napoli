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