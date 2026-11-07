import Foundation
import NAPIC

public protocol ErrorConvertible: Swift.Error {
    var message: String { get }
    var code: String? { get }
}

extension Error {
    func throwInJS(_ env: Environment) {
        if let error = self as? JSError {
            try! napi_throw(env.env, error.napiValue(env)).throwIfError()
        } else if let error = self as? ErrorConvertible {
            try! napi_throw_error(env.env, error.code, error.message).throwIfError()
        } else {
            try! napi_throw_error(env.env, nil, String(describing: self)).throwIfError()
        }
    }
}

public typealias Callback = (Environment, Arguments) throws -> ValueConvertible

class CallbackData {
    let callback: Callback

    init(callback: @escaping Callback) {
        self.callback = callback
    }
}

class GetSetCallbackData {
    let getter: Callback
    let setter: Callback

    init(getter: @escaping Callback, setter: @escaping Callback) {
        self.getter = getter
        self.setter = setter
    }
}

func swiftNAPICallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
    let env = Environment(env)
    var args = NullableArguments(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 10, nil)
    let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)

    napi_get_cb_info(env.env, cbinfo, &args.length, &args.0, &args.this, dataPointer)
    let data = Unmanaged<CallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

    do {
        return try data.callback(env, args as! Arguments).napiValue(env)
    } catch NAPIError.pendingException {
        return nil
    } catch {
        if !env.exceptionIsPending() { error.throwInJS(env) }
        return nil
    }
}

func swiftNAPIGetterCallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
    let env = Environment(env)
    var args = NullableArguments(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 10, nil)
    let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)

    napi_get_cb_info(env.env, cbinfo, &args.length, &args.0, &args.this, dataPointer)
    let data = Unmanaged<GetSetCallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

    do {
        return try data.getter(env, args as! Arguments).napiValue(env)
    } catch NAPIError.pendingException {
        return nil
    } catch {
        if !env.exceptionIsPending() { error.throwInJS(env) }
        return nil
    }
}

func swiftNAPISetterCallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
    let env = Environment(env)
    var args = NullableArguments(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 10, nil)
    let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)

    napi_get_cb_info(env.env, cbinfo, &args.length, &args.0, &args.this, dataPointer)
    let data = Unmanaged<GetSetCallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

    do {
        return try data.setter(env, args as! Arguments).napiValue(env)
    } catch NAPIError.pendingException {
        return nil
    } catch {
        if !env.exceptionIsPending() { error.throwInJS(env) }
        return nil
    }
}

func swiftNAPIFunctionFinalize(_: napi_env!, _ data: UnsafeMutableRawPointer!, _: UnsafeMutableRawPointer?) {
    Unmanaged<CallbackData>.fromOpaque(data).release()
}
