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

func returnArrayBuffer() -> Data {
    Data([223, 123, 44, 52, 32])
}

func returnNull() -> Null {
    Null.default
}

func returnError() -> JSError {
    .init(code: "ERR_TEST_ERROR", message: "a glorious message")
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

func takeArrayBuffer(data: Data) throws {
    try assertEqual(expected: Data([12, 44, 35, 10]), actual: data)
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

func takeError(value: JSError) throws {
    try assertEqual(expected: .init(code: "neat code", message: "a message"), actual: value)
}

func takeSuccessfulPromise(promise: Promise<String>) async throws {
    try assertEqual(expected: try await promise.value, actual: "cool I did it!")
}

func takeThrowingPromise(promise: Promise<String>) async throws {
    do {
        _ = try await promise.value
        throw TestError(message: "promise must throw")
    } catch let error as JSError {
        try assertEqual(expected: "lol sorry", actual: error.message)
    } catch {
        throw TestError(message: "promise error must be JSError")
    }
}

func modifyObjectByReferenceAsync(object: ObjectReference) async throws {
    try assertEqual(expected: "bad", actual: try await object.get("cool"))
    try await Task.sleep(seconds: 0.01)
    try await object.set("cool", value: "neat")
    try await Task.sleep(seconds: 0.01)
    try await object.set("additional", value: "good")
    try assertEqual(expected: "neat", actual: try await object.get("cool"))
    try assertEqual(expected: "good", actual: try await object.get("additional"))
}

func modifyObjectByReferenceSync(env: Environment, object: ObjectReference) throws {
    try assertEqual(expected: "bad", actual: try object.get(env, "cool"))
    try object.set(env, "cool", value: "neat")
    try object.set(env, "additional", value: "good")
    try assertEqual(expected: "neat", actual: try object.get(env, "cool"))
    try assertEqual(expected: "good", actual: try object.get(env, "additional"))
}

func testEnvironment(env: Environment) throws -> String {
    try env.global().json().stringify(TestObject())
}

func testEnvironmentAsync(env: Environment) throws -> Promise<String> {
    let accessor = try EnvironmentAccessor(env)

    return Promise {
        try await accessor.withEnvironment { env in
            try env.global().json().stringify(TestObject())
        }
    }
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

func takeTypedCallback(env: Environment, fn: TypedFunction2<String, Int32, Bool>) throws {
    try assertEqual(expected: "23true", actual: try fn.call(env, 23, true))
}

func emitOnEventEmitter(env: Environment, emitter: EventEmitter) throws {
    try emitter.emit(env, "channel5", "hello from swiftland", "hello from swiftland2")
}

func emitOnEventEmitterAsync(emitter: EventEmitter) async throws {
    try await emitter.emit("channel11", "hello from swiftland async")
}

func receiveOnEventEmitter(emitter: EventEmitter, onReady: ThreadsafeTypedFunction0<Undefined>) async throws {
    _ = try await withCheckedThrowingContinuation { c in
        Task {
            try await emitter.on("channel23Async") { (int: Int32, string: String, dict: [String: Int32]) in
                do {
                    try assertEqual(expected: 22, actual: int)
                    try assertEqual(expected: "test", actual: string)
                    try assertEqual(expected: ["a": 1, "b": 2], actual: dict)
                    c.resume()
                } catch {
                    c.resume(throwing: error)
                }
            }
            try await onReady.call()
        }
    }
}

actor TestActor: ClassDescribable {
    var storage: Int32 = 24
    init() {}

    @Sendable func cool(_ string: String) async throws -> Int32 {
        try assertEqual(expected: "I love actors!", actual: string)
        return 44
    }

    @Sendable func mutateStorage(_ new: Int32) async {
        storage = new
    }

    @Sendable func getStorage() async -> Int32 {
        storage
    }

    static let jsInstanceMethods: [InstanceMethodDescriptor<TestActor>] = [
        .init("cool", cool),
        .init("mutateStorage", mutateStorage),
        .init("getStorage", getStorage)
    ]
}

final class TestClass1: ClassDescribable {
    var testString: String = "Cool"
    var testNumber: Double = 1234
    var testObject = TestObject()

    var readOnlyTestString: String {
        "ReadOnlyTest"
    }

    func reset() {
        testString = "Cool"
        testNumber = 1234
        testObject = TestObject()
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
        .init("assertTestNumber", TestClass1.assertTestNumber),
    ]
}

struct TestObject: ImmutableObjectConvertible {
    var testString: String = "testString"
    var optionalString: String? = "optionalTestString"
    var optionalString2: String?
    var nested: Nested = .init(nestedTestString: "nestedTestString")
    var optionalNested: Nested?

    struct Nested: ImmutableObjectConvertible {
        var nestedTestString: String
    }
}

@_cdecl("_init_napoli_tests")
func initNapoliTests(env: OpaquePointer, exports: OpaquePointer) -> OpaquePointer? {
    initModule(env, exports, [
        MethodDescriptor("returnString", returnString),
        MethodDescriptor("returnDouble", returnDouble),
        MethodDescriptor("returnBoolean", returnBoolean),
        MethodDescriptor("returnArrayBuffer", returnArrayBuffer),
        MethodDescriptor("returnDate", returnDate),
        MethodDescriptor("returnInt64", returnInt64),
        MethodDescriptor("returnInt32", returnInt32),
        MethodDescriptor("returnUInt32", returnUInt32),
        MethodDescriptor("returnNull", returnNull),
        MethodDescriptor("returnUndefined", returnUndefined),
        MethodDescriptor("returnError", returnError),

        MethodDescriptor("takeString", takeString),
        MethodDescriptor("takeDouble", takeDouble),
        MethodDescriptor("takeBoolean", takeBoolean),
        MethodDescriptor("takeDate", takeDate),
        MethodDescriptor("takeNull", takeNull),
        MethodDescriptor("takeUndefined", takeUndefined),
        MethodDescriptor("takeArrayBuffer", takeArrayBuffer),
        MethodDescriptor("takeError", takeError),
        MethodDescriptor("takeSuccessfulPromise", takeSuccessfulPromise),
        MethodDescriptor("takeThrowingPromise", takeThrowingPromise),

        MethodDescriptor("takeOptionalString", takeOptionalString),
        MethodDescriptor("takeOptionalDouble", takeOptionalDouble),
        MethodDescriptor("takeOptionalBoolean", takeOptionalBoolean),

        MethodDescriptor("testEnvironment", testEnvironment),
        MethodDescriptor("testEnvironmentAsync", testEnvironmentAsync),

        MethodDescriptor("throwError", throwError),
        MethodDescriptor("runThreadsafeCallback", runThreadsafeCallback),
        MethodDescriptor("returnSuccessfulPromise", returnSuccessfulPromise),
        MethodDescriptor("returnThrowingPromise", returnThrowingPromise),
        MethodDescriptor("takeTypedCallback", takeTypedCallback),
        MethodDescriptor("modifyObjectByReferenceAsync", modifyObjectByReferenceAsync),
        MethodDescriptor("modifyObjectByReferenceSync", modifyObjectByReferenceSync),

        MethodDescriptor("emitOnEventEmitter", emitOnEventEmitter),
        MethodDescriptor("emitOnEventEmitterAsync", emitOnEventEmitterAsync),
        MethodDescriptor("receiveOnEventEmitter", receiveOnEventEmitter),
        ClassDescriptor(TestClass1.self),
        ClassDescriptor(TestActor.self)
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
