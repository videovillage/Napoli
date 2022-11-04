import Foundation
import NAPIC

private func setTimeout(_ env: napi_env, _ fn: Function, _ ms: Double) throws {
    var global: napi_value!
    try napi_get_global(env, &global).throwIfError()

    var setTimeout: napi_value!
    try napi_get_named_property(env, global, "setTimeout", &setTimeout).throwIfError()

    try Function(env, from: setTimeout).call(env, fn, ms)
}

public enum RunLoop {
    private static var refCount = 0
    private static var scheduled = false

    private static func tick(_ env: napi_env) throws {
        guard RunLoop.refCount > 0 else {
            RunLoop.scheduled = false
            return
        }

        _ = Foundation.RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.02))

        try setTimeout(env, Function(named: "tick", RunLoop.tick), 0)
    }

    public static func ref(_ env: napi_env) throws {
        RunLoop.refCount += 1

        if RunLoop.scheduled == false {
            RunLoop.scheduled = true
            try setTimeout(env, Function(named: "tick", RunLoop.tick), 0)
        }
    }

    public static func unref() {
        RunLoop.refCount -= 1
    }
}
