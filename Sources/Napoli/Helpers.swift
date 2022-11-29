import NAPIC

public func strictlyEquals(_ env: Environment, lhs: napi_value, rhs: napi_value) throws -> Bool {
    var isEqual = false
    try napi_strict_equals(env.env, lhs, rhs, &isEqual).throwIfError()
    return isEqual
}

public func strictlyEquals(_ env: Environment, lhs: napi_value, rhs: ValueConvertible) throws -> Bool {
    try strictlyEquals(env, lhs: lhs, rhs: rhs.napiValue(env))
}

public func strictlyEquals(_ env: Environment, lhs: ValueConvertible, rhs: napi_value) throws -> Bool {
    try strictlyEquals(env, lhs: lhs.napiValue(env), rhs: rhs)
}

public func strictlyEquals(_ env: Environment, lhs: ValueConvertible, rhs: ValueConvertible) throws -> Bool {
    try strictlyEquals(env, lhs: lhs.napiValue(env), rhs: rhs.napiValue(env))
}

public func defineProperties(_ env: Environment, _ object: napi_value, _ properties: [PropertyDescriptor]) throws {
    let props = try properties.map { try $0.propertyDescriptor(env) }

    try props.withUnsafeBufferPointer { propertiesBytes in
        napi_define_properties(env.env, object, properties.count, propertiesBytes.baseAddress)
    }.throwIfError()
}

public actor EnvironmentAccessor {
    private let function: ThreadsafeTypedFunction1<Undefined, TypedFunction0<Undefined>>

    public init(_ env: Environment) throws {
        function = try .init(env, .init(named: "envAccessor") { env, f in
            try f.call(env)
            return Undefined.default
        })
    }

    public func withEnvironment<T>(_ closure: @escaping (Environment) throws -> T) async throws -> T {
        var result: Result<T, Swift.Error>!
        try await function.call(.init(named: "withEnvironmentCallback") { env in
            do {
                result = .success(try closure(env))
            } catch {
                result = .failure(error)
            }
            return Undefined.default
        })

        return try result.get()
    }

    public func withEnvironment(_ closure: @escaping (Environment) throws -> Void) async throws {
        var resultError: Swift.Error?
        try await function.call(.init(named: "withEnvironmentCallback") { env in
            do {
                try closure(env)
            } catch {
                resultError = error
            }

            return Undefined.default
        })

        if let resultError {
            throw resultError
        }
    }
}

public func initModule(_ env: napi_env, _ exports: napi_value, _ properties: [PropertyDescriptor]) -> napi_value {
    try! defineProperties(Environment(env), exports, properties)
    return exports
}
