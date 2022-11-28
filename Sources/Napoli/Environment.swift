import Foundation
import NAPIC

public struct Environment {
    let env: napi_env

    init(_ env: napi_env) {
        self.env = env
    }
}