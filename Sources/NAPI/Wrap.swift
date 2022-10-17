import NAPIC

func swiftNAPIDeinit(_: napi_env!, pointer: UnsafeMutableRawPointer?, hint _: UnsafeMutableRawPointer?) {
    Unmanaged<AnyObject>.fromOpaque(pointer!).release()
}

class Wrap<T: AnyObject> {
    static func wrap(_ env: napi_env, jsObject: napi_value, nativeObject: T) throws {
        let pointer = Unmanaged.passRetained(nativeObject).toOpaque()
        let status = napi_wrap(env, jsObject, pointer, swiftNAPIDeinit, nil, nil)
        guard status == napi_ok else { throw NAPI.Error(status) }
    }

    static func unwrap(_ env: napi_env, jsObject: napi_value) throws -> T {
        var pointer: UnsafeMutableRawPointer?

        let status = napi_unwrap(env, jsObject, &pointer)
        guard status == napi_ok else { throw NAPI.Error(status) }

        return Unmanaged<T>.fromOpaque(pointer!).takeUnretainedValue()
    }
}
