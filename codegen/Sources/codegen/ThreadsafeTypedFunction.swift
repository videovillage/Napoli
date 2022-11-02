import Foundation

enum ThreadsafeTypedFunction {
    static func generate(maxParams: Int) throws -> Source {
        var source = Source()

        source.add("import NAPIC")
        source.newline()
        source.add("""
            class ThreadsafeFunctionCallbackData {
                typealias Continuation = CheckedContinuation<ValueConvertible, Swift.Error>
                typealias ResultConstructor = (napi_env, napi_value) throws -> ValueConvertible
                let this: ValueConvertible
                let args: [ValueConvertible]
                let continuation: Continuation
                let resultConstructor: ResultConstructor

                init<Result: ValueConvertible>(this: ValueConvertible, args: [ValueConvertible], continuation: Continuation, resultType _: Result.Type) {
                    self.this = this
                    self.args = args
                    self.continuation = continuation
                    resultConstructor = { env, val in try Result(env, from: val) }
                }

                init(this: ValueConvertible, args: [ValueConvertible], continuation: Continuation) {
                    self.this = this
                    self.args = args
                    self.continuation = continuation
                    resultConstructor = { _, _ in Undefined.default }
                }
            }

            func newNAPIThreadsafeFinalize(_: napi_env!, pointer _: UnsafeMutableRawPointer?, hint _: UnsafeMutableRawPointer?) {}

            func newNAPIThreadsafeCallback(_ env: napi_env?, _ js_callback: napi_value?, _: UnsafeMutableRawPointer?, _ data: UnsafeMutableRawPointer!) {
                let callbackData = Unmanaged<ThreadsafeFunctionCallbackData>.fromOpaque(data).takeRetainedValue()

                var result: napi_value?

                if let env {
                    do {
                        let this = try callbackData.this.napiValue(env)
                        let args: [napi_value?] = try callbackData.args.map { try $0.napiValue(env) }
                        try args.withUnsafeBufferPointer { argsBytes in
                            napi_call_function(env, this, js_callback, args.count, argsBytes.baseAddress, &result)
                        }.throwIfError()

                        try callbackData.continuation.resume(returning: callbackData.resultConstructor(env, result!))
                    } catch {
                        if try! exceptionIsPending(env) {
                            var errorResult: napi_value!
                            try! napi_get_and_clear_last_exception(env, &errorResult).throwIfError()
                            callbackData.continuation.resume(throwing: JSException(value: errorResult))
                        } else {
                            callbackData.continuation.resume(throwing: error)
                        }
                    }
                }
            }

            private func _call(tsfn: napi_threadsafe_function, this: ValueConvertible, args: [ValueConvertible]) async throws {
                try napi_acquire_threadsafe_function(tsfn).throwIfError()
                defer { napi_release_threadsafe_function(tsfn, napi_tsfn_release) }

                _ = try await withCheckedThrowingContinuation { continuation in
                    let unmanagedData = Unmanaged.passRetained(ThreadsafeFunctionCallbackData(this: this, args: args, continuation: continuation))
                    napi_call_threadsafe_function(tsfn, unmanagedData.toOpaque(), napi_tsfn_nonblocking)
                }
            }

            private func _call<Result: ValueConvertible>(tsfn: napi_threadsafe_function, this: ValueConvertible, args: [ValueConvertible], resultType: Result.Type) async throws -> Result {
                try napi_acquire_threadsafe_function(tsfn).throwIfError()
                defer { napi_release_threadsafe_function(tsfn, napi_tsfn_release) }

                return try await withCheckedThrowingContinuation { continuation in
                    let unmanagedData = Unmanaged.passRetained(ThreadsafeFunctionCallbackData(this: this, args: args, continuation: continuation, resultType: resultType))
                    napi_call_threadsafe_function(tsfn, unmanagedData.toOpaque(), napi_tsfn_nonblocking)
                } as! Result
            }
            """)
        source.newline()

        for i in (0 ..< maxParams).reversed() {
            try generateClass(source: &source, paramCount: i)
        }

        return source
    }

    static func generateClass(source: inout Source, paramCount: Int) throws {
        let resultGeneric = Generic(type: "Result")
        let inGenerics = [Generic](prefix: "P", count: paramCount)
        let allGenerics = [resultGeneric] + inGenerics
        let wheres = allGenerics.conforming(to: Types.valueConvertible)
        let commaSeparatedInGenerics = inGenerics.map(\.type).commaSeparated

        let inGenericsAsArgs: String
        if paramCount > 0 {
            inGenericsAsArgs = ", " + inGenerics.map { "_ \($0.type.lowercased()): \($0.type)" }.commaSeparated
        } else {
            inGenericsAsArgs = ""
        }

        let inGenericsAsNAPI = inGenerics.map { "\($0.type.lowercased()).napiValue(env)" }.commaSeparated

        try source.declareClass(.public, "NewThreadsafeTypedFunction\(paramCount)", genericParams: allGenerics, conformsTo: Types.valueConvertible, wheres: wheres) { source in
            source.add("""
            public typealias InternalFunction = NewTypedFunction\(paramCount)\(allGenerics.bracketedOrNone)
            fileprivate var tsfn: napi_threadsafe_function!

            public required convenience init(_ env: napi_env, from: napi_value) throws {
                let function = try InternalFunction(env, from: from)
                try self.init(env, function)
            }

            public func napiValue(_ env: napi_env) throws -> napi_value {
                try Undefined.default.napiValue(env)
            }

            public init(_ env: napi_env, _ function: InternalFunction) throws {
                try napi_create_threadsafe_function(env,
                                                    function.napiValue(env),
                                                    nil,
                                                    "ThreadsafeWrapper".napiValue(env),
                                                    0,
                                                    1,
                                                    nil,
                                                    newNAPIThreadsafeFinalize,
                                                    nil,
                                                    newNAPIThreadsafeCallback,
                                                    &tsfn).throwIfError()
            }

            public func call(this: ValueConvertible = Undefined.default\(inGenericsAsArgs)) async throws where Result == Undefined {
                try await _call(tsfn: tsfn, this: this, args: [\(inGenerics.map { $0.type.lowercased() }.commaSeparated)])
            }

            public func call(this: ValueConvertible = Undefined.default\(inGenericsAsArgs)) async throws -> Result {
                try await _call(tsfn: tsfn, this: this, args: [\(inGenerics.map { $0.type.lowercased() }.commaSeparated)], resultType: Result.self)
            }

            deinit {
                if let tsfn {
                    napi_release_threadsafe_function(tsfn, napi_tsfn_release)
                }
            }
            """)
        }
    }
}