import Foundation
import NAPI

struct TestError: Swift.Error, ErrorConvertible {
    public var message: String
    public var code: String?
}

func assertEqual<T: Equatable & CustomStringConvertible>(expected: T, actual: T) throws {
    guard expected == actual else {
        throw TestError(message: "Expected values to be equal:\n\n\(expected) !== \(actual)\n", code: "ERR_ASSERTION")
    }
}

func returnString() -> String {
    "a string"
}

func returnNumber() -> Double {
    1337
}

func returnBoolean() -> Bool {
    true
}

func returnNull() -> Value {
    .null
}

func returnUndefined() -> Value {
    .undefined
}

func takeString(value: String) throws {
    try assertEqual(expected: "a string", actual: value)
}

func takeNumber(value: Double) throws {
    try assertEqual(expected: 1337, actual: value)
}

func takeBoolean(value: Bool) throws {
    try assertEqual(expected: true, actual: value)
}

func takeNull(value: Null) throws {
    try assertEqual(expected: Null.default, actual: value)
}

func takeUndefined(value: Undefined) throws {
    try assertEqual(expected: Undefined.default, actual: value)
}

func takeOptionalString(value: String?) -> String {
    value ?? "a string"
}

func takeOptionalNumber(value: Double?) -> Double {
    value ?? 1337
}

func takeOptionalBoolean(value: Bool?) -> Bool {
    value ?? true
}

func throwError() throws {
    throw TestError(message: "Error message", code: "ETEST")
}

func runThreadsafeCallback(env: OpaquePointer, fn: Function) throws -> Void {
    let tsfn = try ThreadsafeFunction(env, fn)

    Task {
        do {
            let value: String = try await tsfn.call("hello world")
            try assertEqual(expected: "message", actual: value)
        } catch {
            print("runThreadsafeCallback error: \(error)")
        }
    }
}

func returnSuccessfulPromise(env: OpaquePointer, msg: String) throws -> Promise {
    try Promise(env) {
        try await Task.sleep(seconds: 0.2)
        return msg + " hello"
    }
}

func returnThrowingPromise(env: OpaquePointer, msg: String) throws -> Promise {
    func asyncThrow() async throws -> Void {
        enum Error: Swift.Error {
            case genericError
        }

        try await Task.sleep(seconds: 0.2)
        throw Error.genericError
    }

    return try Promise(env, asyncThrow)
}

@_cdecl("_init_napi_tests")
func initNAPITests(env: OpaquePointer, exports: OpaquePointer) -> OpaquePointer? {
    initModule(env, exports, [
        .function("returnString", returnString),
        .function("returnNumber", returnNumber),
        .function("returnBoolean", returnBoolean),
        .function("returnNull", returnNull),
        .function("returnUndefined", returnUndefined),

        .function("takeString", takeString),
        .function("takeNumber", takeNumber),
        .function("takeBoolean", takeBoolean),
        .function("takeNull", takeNull),
        .function("takeUndefined", takeUndefined),

        .function("takeOptionalString", takeOptionalString),
        .function("takeOptionalNumber", takeOptionalNumber),
        .function("takeOptionalBoolean", takeOptionalBoolean),

        .function("throwError", throwError),
        .function("runThreadsafeCallback", runThreadsafeCallback),
        .function("returnSuccessfulPromise", returnSuccessfulPromise),
        .function("returnThrowingPromise", returnThrowingPromise)
    ])
}

enum TimeIntervalSleepError: Swift.Error {
    case negativeTimeInterval
}

public extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: TimeInterval) async throws {
        guard seconds >= 0 else { throw TimeIntervalSleepError.negativeTimeInterval }
        try await sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
