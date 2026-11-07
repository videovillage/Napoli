import Foundation
import NAPIC

private var jsThread: Thread?

public extension Thread {
    static var isJSThread: Bool {
        jsThread === Thread.current
    }
}

public struct Environment {
    private let _env: napi_env

    public var env: napi_env {
        guard Thread.isJSThread else {
            fatalError("tried to use napi_env from non-JS thread")
        }
        return _env
    }

    public init(_ env: napi_env) {
        _env = env
        if jsThread == nil { jsThread = Thread.current }
    }

    public func exceptionIsPending() -> Bool {
        var result = false
        napi_is_exception_pending(env, &result)
        return result
    }
}
