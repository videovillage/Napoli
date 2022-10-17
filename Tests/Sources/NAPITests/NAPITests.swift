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
    ])
}
