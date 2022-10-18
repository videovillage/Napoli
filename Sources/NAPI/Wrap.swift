import NAPIC

func swiftNAPIDeinit(_: napi_env!, pointer: UnsafeMutableRawPointer?, hint _: UnsafeMutableRawPointer?) {
    Unmanaged<AnyObject>.fromOpaque(pointer!).release()
}

class Wrap<T: AnyObject> {
    static func wrap(_ env: napi_env, jsObject: napi_value, nativeObject: T) throws {
        let pointer = Unmanaged.passRetained(nativeObject).toOpaque()
        try napi_wrap(env, jsObject, pointer, swiftNAPIDeinit, nil, nil).throwIfError()
    }

    static func unwrap(_ env: napi_env, jsObject: napi_value) throws -> T {
        var pointer: UnsafeMutableRawPointer?

        try napi_unwrap(env, jsObject, &pointer).throwIfError()

        return Unmanaged<T>.fromOpaque(pointer!).takeUnretainedValue()
    }
}
