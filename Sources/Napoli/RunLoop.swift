import Foundation
import NAPIC

private func setTimeout(_ env: Environment, _ fn: TypedFunction0<Undefined>, _ ms: Double) throws {
    var global: napi_value!
    try napi_get_global(env.env, &global).throwIfError()

    var setTimeout: napi_value!
    try napi_get_named_property(env.env, global, "setTimeout", &setTimeout).throwIfError()

    try TypedFunction2<Undefined, TypedFunction0<Undefined>, Double>(env, from: setTimeout).call(env, fn, ms)
}

public enum RunLoop {
    private static var refCount = 0
    private static var scheduled = false

    private static func tick(_ env: Environment) throws {
        guard RunLoop.refCount > 0 else {
            RunLoop.scheduled = false
            return
        }

        _ = Foundation.RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.02))

        try setTimeout(env, .init(named: "tick", RunLoop.tick), 0)
    }

    public static func ref(_ env: Environment) throws {
        RunLoop.refCount += 1

        if RunLoop.scheduled == false {
            RunLoop.scheduled = true
            try setTimeout(env, .init(named: "tick", RunLoop.tick), 0)
        }
    }

    public static func unref() {
        RunLoop.refCount -= 1
    }
}
