import Foundation

enum ThreadsafeTypedFunction {
    static func generate(maxParams: Int) throws -> Source {
        var source = Source()

        source.add("import NAPIC")
        source.newline()
        source.add("""
        class ThreadsafeFunctionCallbackData {
            typealias Continuation = CheckedContinuation<ValueConvertible, Swift.Error>
            typealias ResultConstructor = (Environment, napi_value) throws -> ValueConvertible
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

        func typedFuncNAPIThreadsafeCallback(_ env: napi_env?, _ js_callback: napi_value?, _: UnsafeMutableRawPointer?, _ data: UnsafeMutableRawPointer!) {
            let callbackData = Unmanaged<ThreadsafeFunctionCallbackData>.fromOpaque(data).takeRetainedValue()

            var result: napi_value?

            if let env, let js_callback {
                let env = Environment(env)
                do {
                    let this = try callbackData.this.napiValue(env)
                    let args: [napi_value?] = try callbackData.args.map { try $0.napiValue(env) }
                    try args.withUnsafeBufferPointer { argsBytes in
                        napi_call_function(env.env, this, js_callback, args.count, argsBytes.baseAddress, &result)
                    }.throwIfError()

                    try callbackData.continuation.resume(returning: callbackData.resultConstructor(env, result!))
                } catch {
                    if env.exceptionIsPending() {
                        var errorResult: napi_value!
                        try! napi_get_and_clear_last_exception(env.env, &errorResult).throwIfError()
                        let error = try! JSError(env, from: errorResult)
                        callbackData.continuation.resume(throwing: error)
                    } else {
                        callbackData.continuation.resume(throwing: error)
                    }
                }
            } else {
                callbackData.continuation.resume(throwing: NAPIError.closing)
            }
        }

        private func _call(lifetime: ThreadsafeFunctionLifetime, this: ValueConvertible, args: [ValueConvertible]) async throws {
            _ = try await withCheckedThrowingContinuation { continuation in
                let unmanagedData = Unmanaged.passRetained(ThreadsafeFunctionCallbackData(this: this, args: args, continuation: continuation))
                let callStatus = lifetime.enqueue(unmanagedData.toOpaque())
                if callStatus != napi_ok {
                    unmanagedData.release()
                    continuation.resume(throwing: NAPIError(callStatus))
                }
            }
        }

        private func _call<Result: ValueConvertible>(lifetime: ThreadsafeFunctionLifetime, this: ValueConvertible, args: [ValueConvertible], resultType: Result.Type) async throws -> Result {
            return try await withCheckedThrowingContinuation { continuation in
                let unmanagedData = Unmanaged.passRetained(ThreadsafeFunctionCallbackData(this: this, args: args, continuation: continuation, resultType: resultType))
                let callStatus = lifetime.enqueue(unmanagedData.toOpaque())
                if callStatus != napi_ok {
                    unmanagedData.release()
                    continuation.resume(throwing: NAPIError(callStatus))
                }
            } as! Result
        }

        /// A type-erased threadsafe typed function
        public class ThreadsafeTypedFunction {
            fileprivate let lifetime = ThreadsafeFunctionLifetime()

            init() {}

            deinit {
                lifetime.releaseOwner()
            }
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

        let inGenericsAsArgs: String
        if paramCount > 0 {
            inGenericsAsArgs = ", " + inGenerics.map { "_ \($0.type.lowercased()): \($0.type)" }.commaSeparated
        } else {
            inGenericsAsArgs = ""
        }

        let docs = """
        A threadsafe and type-safe function with return type `Result`\(paramCount > 0 ? " and \(paramCount) parameter\(paramCount == 1 ? "" : "s")" : "").
        """

        try source.declareClass(.public, "ThreadsafeTypedFunction\(paramCount)", genericParams: allGenerics, conformsTo: "ThreadsafeTypedFunction, ValueConvertible", wheres: wheres, docs: docs) { source in
            source.add("""
            public typealias InternalFunction = TypedFunction\(paramCount)\(allGenerics.bracketedOrNone)

            public required convenience init(_ env: Environment, from: napi_value) throws {
                let function = try InternalFunction(env, from: from)
                try self.init(env, function)
            }

            public func napiValue(_ env: Environment) throws -> napi_value {
                try Undefined.default.napiValue(env)
            }

            public init(_ env: Environment, _ function: InternalFunction) throws {
                super.init()
                try lifetime.initialize(env, function: function.napiValue(env))
            }

            public func call(this: ValueConvertible = Undefined.default\(inGenericsAsArgs)) async throws where Result == Undefined {
                try await _call(lifetime: lifetime, this: this, args: [\(inGenerics.map { $0.type.lowercased() }.commaSeparated)])
            }

            public func call(this: ValueConvertible = Undefined.default\(inGenericsAsArgs)) async throws -> Result {
                try await _call(lifetime: lifetime, this: this, args: [\(inGenerics.map { $0.type.lowercased() }.commaSeparated)], resultType: Result.self)
            }
            """)
        }
    }
}
