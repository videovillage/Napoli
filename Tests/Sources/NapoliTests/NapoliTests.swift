import Foundation
import Napoli

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

final class TestClass1: ClassConvertible {
    var testString: String = "Cool"
    var testNumber: Double = 1234
    var testObject = TestObject(testString: "testString", optionalString: "optionalTestString", nested: .init(nestedTestString: "nestedTestString"), optionalNested: nil)

    var readOnlyTestString: String {
        "ReadOnlyTest"
    }

    func reset() {
        testString = "Cool"
        testNumber = 1234
        testObject = TestObject(testString: "testString", optionalString: "optionalTestString", nested: .init(nestedTestString: "nestedTestString"), optionalNested: nil)
    }

    func assertTestString(_ string: String) throws {
        try assertEqual(expected: string, actual: testString)
    }

    func assertTestNumber(_ number: Double) throws {
        try assertEqual(expected: number, actual: testNumber)
    }

    func testThrowError() throws {
        try throwError()
    }

    required init() {}

    static let jsName = "TestClass1"
    static let jsInstanceProperties: [InstanceGetSetPropertyDescriptor<TestClass1>] = [
        .init("testObject", keyPath: \.testObject),
        .init("testString", keyPath: \.testString),
        .init("testNumber", keyPath: \.testNumber),
        .init("readOnlyTestString", keyPath: \.readOnlyTestString),
    ]
    static let jsInstanceMethods: [InstanceMethodDescriptor<TestClass1>] = [
        .init("reset", TestClass1.reset),
        .init("testThrowError", TestClass1.testThrowError),
        .init("assertTestString", TestClass1.assertTestString),
        .init("assertTestNumber", TestClass1.assertTestNumber)
    ]
}

struct TestObject: ObjectConvertible {
    let testString: String
    let optionalString: String?
    let nested: Nested
    let optionalNested: Nested?

    struct Nested: ObjectConvertible {
        let nestedTestString: String
    }
}

@_cdecl("_init_napoli_tests")
func initNapoliTests(env: OpaquePointer, exports: OpaquePointer) -> OpaquePointer? {
    initModule(env, exports, [
        MethodDescriptor("returnString", returnString),
        MethodDescriptor("returnDouble", returnDouble),
        MethodDescriptor("returnBoolean", returnBoolean),
        MethodDescriptor("returnDate", returnDate),
        MethodDescriptor("returnInt64", returnInt64),
        MethodDescriptor("returnInt32", returnInt32),
        MethodDescriptor("returnUInt32", returnUInt32),
        MethodDescriptor("returnNull", returnNull),
        MethodDescriptor("returnUndefined", returnUndefined),

        MethodDescriptor("takeString", takeString),
        MethodDescriptor("takeDouble", takeDouble),
        MethodDescriptor("takeBoolean", takeBoolean),
        MethodDescriptor("takeDate", takeDate),
        MethodDescriptor("takeNull", takeNull),
        MethodDescriptor("takeUndefined", takeUndefined),

        MethodDescriptor("takeOptionalString", takeOptionalString),
        MethodDescriptor("takeOptionalDouble", takeOptionalDouble),
        MethodDescriptor("takeOptionalBoolean", takeOptionalBoolean),

        MethodDescriptor("throwError", throwError),
        MethodDescriptor("runThreadsafeCallback", runThreadsafeCallback),
        MethodDescriptor("returnSuccessfulPromise", returnSuccessfulPromise),
        MethodDescriptor("returnThrowingPromise", returnThrowingPromise),
        MethodDescriptor("takeTypedCallback", takeTypedCallback),
        ClassDescriptor(TestClass1.self),
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
