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

func returnDouble() -> Double {
    1337
}

func returnInt32() -> Int32 {
    Int32.min
}

func returnUInt32() -> UInt32 {
    UInt32.max
}

func returnInt64() -> Int64 {
    .jsSafeRange.lowerBound
}

func returnBoolean() -> Bool {
    true
}

func returnNull() -> Null {
    Null.default
}

func returnUndefined() -> Undefined {
    Undefined.default
}

func returnDate() -> Date {
    .init(timeIntervalSince1970: 1000)
}

func takeString(value: String) throws {
    try assertEqual(expected: "a string", actual: value)
}

func takeDouble(value: Double) throws {
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

func takeDate(date: Date) throws {
    try assertEqual(expected: 1000, actual: date.timeIntervalSince1970)
}

func takeOptionalString(value: String?) -> String {
    value ?? "a string"
}

func takeOptionalDouble(value: Double?) -> Double {
    value ?? 1337
}

func takeOptionalBoolean(value: Bool?) -> Bool {
    value ?? true
}

func throwError() throws {
    throw TestError(message: "Error message", code: "ETEST")
}

func runThreadsafeCallback(tsfn: NewThreadsafeTypedFunction1<String, String>) throws {
    Task {
        try? await Task.sleep(seconds: 0.1)
        do {
            let value: String = try await tsfn.call("hello world")
            try assertEqual(expected: "message", actual: value)
        } catch {
            print("runThreadsafeCallback error: \(error)")
        }
    }
}

func returnSuccessfulPromise(msg: String) -> Promise<String> {
    Promise {
        try await Task.sleep(seconds: 0.1)
        return msg + " hello"
    }
}

func returnThrowingPromise(msg _: String) -> Promise<Void> {
    Promise {
        try await Task.sleep(seconds: 0.1)
        try throwError()
    }
}

func takeTypedCallback(env: OpaquePointer, fn: TypedFunction2<String, Int32, Bool>) throws {
    try assertEqual(expected: "23true", actual: try fn.call(env, 23, true))
}

class TestClass1: JSClassDefinable {
    var testString: String = "Cool"
    var testNumber: Double = 1234

    var readOnlyTestString: String {
        "ReadOnlyTest"
    }

    func reset() {
        testString = "Cool"
        testNumber = 1234
    }

    func testThrowError() throws {
        try throwError()
    }

    required init() {}

    static let jsName = "TestClass1"
    static let jsProperties: [PropertyDescriptor] = [
        .instanceProperty("testString", keyPath: \TestClass1.testString),
        .instanceProperty("testNumber", keyPath: \TestClass1.testNumber),
        .instanceProperty("readOnlyTestString", keyPath: \TestClass1.readOnlyTestString),
    ]
    static let jsFunctions: [PropertyDescriptor] = [
        .instanceMethod("reset") { (me: TestClass1) in me.reset() },
        .instanceMethod("testThrowError") { (me: TestClass1) in try me.testThrowError() },
    ]
}

@_cdecl("_init_napi_tests")
func initNAPITests(env: OpaquePointer, exports: OpaquePointer) -> OpaquePointer? {
    initModule(env, exports, [
        .function("returnString", returnString),
        .function("returnDouble", returnDouble),
        .function("returnBoolean", returnBoolean),
        .function("returnDate", returnDate),
        .function("returnInt64", returnInt64),
        .function("returnInt32", returnInt32),
        .function("returnUInt32", returnUInt32),
        .function("returnNull", returnNull),
        .function("returnUndefined", returnUndefined),

        .function("takeString", takeString),
        .function("takeDouble", takeDouble),
        .function("takeBoolean", takeBoolean),
        .function("takeDate", takeDate),
        .function("takeNull", takeNull),
        .function("takeUndefined", takeUndefined),

        .function("takeOptionalString", takeOptionalString),
        .function("takeOptionalDouble", takeOptionalDouble),
        .function("takeOptionalBoolean", takeOptionalBoolean),

        .function("throwError", throwError),
        .function("runThreadsafeCallback", runThreadsafeCallback),
        .function("returnSuccessfulPromise", returnSuccessfulPromise),
        .function("returnThrowingPromise", returnThrowingPromise),
        .function("takeTypedCallback", takeTypedCallback),
        .class(TestClass1.self),
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
