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

func runThreadsafeCallback(tsfn: ThreadsafeTypedFunction1<String, String>) throws {
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

func returnSuccessfulPromise(msg: String) async throws -> String {
    try await Task.sleep(seconds: 0.1)
    return msg + " hello"
}

func returnThrowingPromise(msg _: String) async throws {
    try await Task.sleep(seconds: 0.1)
    try throwError()
}

func takeTypedCallback(env: OpaquePointer, fn: TypedFunction2<String, Int32, Bool>) throws {
    try assertEqual(expected: "23true", actual: try fn.call(env, 23, true))
}

final class TestClass1: JSClassDefinable {
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
    static let jsInstanceProperties: [InstanceProperty<TestClass1>] = [
        .init("testString", keyPath: \.testString),
        .init("testNumber", keyPath: \.testNumber),
        .init("readOnlyTestString", keyPath: \.readOnlyTestString),
    ]
    static let jsInstanceMethods: [InstanceMethod<TestClass1>] = [
        .init("reset", TestClass1.reset),
        .init("testThrowError", TestClass1.testThrowError),
    ]
}

@_cdecl("_init_napi_tests")
func initNAPITests(env: OpaquePointer, exports: OpaquePointer) -> OpaquePointer? {
    initModule(env, exports, [
        Method("returnString", returnString),
        Method("returnDouble", returnDouble),
        Method("returnBoolean", returnBoolean),
        Method("returnDate", returnDate),
        Method("returnInt64", returnInt64),
        Method("returnInt32", returnInt32),
        Method("returnUInt32", returnUInt32),
        Method("returnNull", returnNull),
        Method("returnUndefined", returnUndefined),

        Method("takeString", takeString),
        Method("takeDouble", takeDouble),
        Method("takeBoolean", takeBoolean),
        Method("takeDate", takeDate),
        Method("takeNull", takeNull),
        Method("takeUndefined", takeUndefined),

        Method("takeOptionalString", takeOptionalString),
        Method("takeOptionalDouble", takeOptionalDouble),
        Method("takeOptionalBoolean", takeOptionalBoolean),

        Method("throwError", throwError),
        Method("runThreadsafeCallback", runThreadsafeCallback),
        Method("returnSuccessfulPromise", returnSuccessfulPromise),
        Method("returnThrowingPromise", returnThrowingPromise),
        Method("takeTypedCallback", takeTypedCallback),
        ClassProperty(TestClass1.self),
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
