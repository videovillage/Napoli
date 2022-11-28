import NAPIC

func swiftNAPIDeinit(_: napi_env!, pointer: UnsafeMutableRawPointer?, hint _: UnsafeMutableRawPointer?) {
    Unmanaged<AnyObject>.fromOpaque(pointer!).release()
}

class Wrap<T: AnyObject> {
    static func wrap(_ env: Environment, jsObject: napi_value, nativeObject: T) throws {
        let pointerData = Unmanaged.passRetained(nativeObject)

        do {
            try napi_wrap(env.env, jsObject, pointerData.toOpaque(), swiftNAPIDeinit, nil, nil).throwIfError()
        } catch {
            pointerData.release()
            throw error
        }
    }

    static func unwrap(_ env: Environment, jsObject: napi_value) throws -> T {
        var pointer: UnsafeMutableRawPointer?

        try napi_unwrap(env.env, jsObject, &pointer).throwIfError()

        return Unmanaged<T>.fromOpaque(pointer!).takeUnretainedValue()
    }
}
