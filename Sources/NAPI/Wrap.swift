import NAPIC

@_cdecl("swift_napi_deinit")
func swiftNAPIDeinit(_ env: napi_env!, pointer: UnsafeMutableRawPointer?, hint: UnsafeMutableRawPointer?) {
    Unmanaged<AnyObject>.fromOpaque(pointer!).release()
}

class Wrap<T: AnyObject> {
    static func wrap(_ env: napi_env, jsObject: napi_value, nativeObject: T) throws {
        let pointerData = Unmanaged.passRetained(nativeObject)

        do {
            try napi_wrap(env, jsObject, pointerData.toOpaque(), swiftNAPIDeinit, nil, nil).throwIfError()
        } catch {
            pointerData.release()
            throw error
        }
    }

    static func unwrap(_ env: napi_env, jsObject: napi_value) throws -> T {
        var pointer: UnsafeMutableRawPointer?

        let status = napi_unwrap(env, jsObject, &pointer)
        guard status == napi_ok else { throw NAPI.Error(status) }

        return Unmanaged<T>.fromOpaque(pointer!).takeUnretainedValue()
    }
}
