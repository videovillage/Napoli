import Foundation
import NAPIC

struct Scope {
    struct OpenedScope {
        fileprivate let scope: napi_handle_scope

        func close(_ env: Environment) {
            try! napi_close_handle_scope(env.env, scope).throwIfError()
        }
    }

    static func open(_ env: Environment) throws -> OpenedScope {
        var scope: napi_handle_scope!
        try napi_open_handle_scope(env.env, &scope).throwIfError()
        return .init(scope: scope)
    }
}
