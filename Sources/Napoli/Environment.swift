import Foundation
import NAPIC

public struct Environment {
    let env: napi_env

    init(_ env: napi_env) {
        self.env = env
    }

    func exceptionIsPending() -> Bool {
        var result = false
        napi_is_exception_pending(env, &result)
        return result
    }
}
