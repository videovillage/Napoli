import Foundation

enum TypedFunction {
    static func generate(maxParams: Int) throws -> Source {
        var source = Source()

        source.add("import NAPIC")
        source.newline()
        source.add("""
        public typealias TypedFunctionCallback = (napi_env, napi_value, [napi_value]) throws -> ValueConvertible

        class TypedFunctionCallbackData {
            let callback: TypedFunctionCallback
            let argCount: Int

            init(callback: @escaping TypedFunctionCallback, argCount: Int) {
                self.callback = callback
                self.argCount = argCount
            }
        }

        func newNAPICallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
            var this: napi_value!
            let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)
            napi_get_cb_info(env, cbinfo, nil, nil, &this, dataPointer)
            let data = Unmanaged<TypedFunctionCallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

            let usedArgs: [napi_value]
            if data.argCount > 0 {
                var args = [napi_value?](repeating: nil, count: data.argCount)
                var argCount = data.argCount

                args.withUnsafeMutableBufferPointer {
                    _ = napi_get_cb_info(env, cbinfo, &argCount, $0.baseAddress, nil, nil)
                }

                assert(argCount == data.argCount)
                usedArgs = args.map { $0! }
            } else {
                usedArgs = []
            }

            do {
                return try data.callback(env, this, usedArgs).napiValue(env)
            } catch NAPI.Error.pendingException {
                return nil
            } catch {
                if try! exceptionIsPending(env) == false { try! throwError(env, error) }
                return nil
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
        let commaSeparatedInGenerics = inGenerics.map(\.type).commaSeparated

        let inGenericsAsArgs: String
        if paramCount > 0 {
            inGenericsAsArgs = ", " + inGenerics.map { "_ \($0.type.lowercased()): \($0.type)" }.commaSeparated
        } else {
            inGenericsAsArgs = ""
        }

        let argListAsParams: String
        if paramCount > 0 {
            argListAsParams = inGenerics.enumerated().map { "\($0.element.type)(env, from: args[\($0.offset)])" }.commaSeparated
        } else {
            argListAsParams = ""
        }

        let argListAssignedToValues: String
        if paramCount > 0 {
            argListAssignedToValues = inGenerics.enumerated().map { "let \($0.element.type.lowercased()) = try \($0.element.type)(env, from: args[\($0.offset)])" }.joined(separator: "; ")
        } else {
            argListAssignedToValues = ""
        }

        let argValueList = inGenerics.map { $0.type.lowercased() }.commaSeparated

        let inGenericsAsNAPI = inGenerics.map { "\($0.type.lowercased()).napiValue(env)" }.commaSeparated

        let docs = """
        A type-safe function with return type `Result`\(paramCount > 0 ? " and \(paramCount) parameter\(paramCount == 1 ? "" : "s")" : "").
        """

        try source.declareClass(.public, "TypedFunction\(paramCount)", genericParams: allGenerics, conformsTo: Types.valueConvertible, wheres: wheres, docs: docs) { source in
            source.add("""
            public typealias ConvenienceCallback = (\(commaSeparatedInGenerics)) throws -> Result
            public typealias ConvenienceVoidCallback = (\(commaSeparatedInGenerics)) throws -> Void
            public typealias AsyncConvenienceCallback<R: ValueConvertible> = (\(commaSeparatedInGenerics)) async throws -> R
            public typealias AsyncConvenienceVoidCallback = (\(commaSeparatedInGenerics)) async throws -> Void

            fileprivate enum InternalTypedFunction {
                case javascript(napi_value)
                case swift(String, TypedFunctionCallback)
            }

            fileprivate let value: InternalTypedFunction

            public required init(_: napi_env, from: napi_value) throws {
                value = .javascript(from)
            }

            public init(named name: String, _ callback: @escaping TypedFunctionCallback) {
                value = .swift(name, callback)
            }

            public convenience init(named name: String, _ callback: @escaping ConvenienceCallback) {
                self.init(named: name) { env, _, args in
                    try callback(\(argListAsParams))
                }
            }

            public convenience init(named name: String, _ callback: @escaping ConvenienceVoidCallback) where Result == Undefined {
                self.init(named: name) { env, _, args in
                    try callback(\(argListAsParams))
                    return Undefined.default
                }
            }

            public convenience init<R: ValueConvertible>(named name: String, _ callback: @escaping AsyncConvenienceCallback<R>) where Result == Promise<R> {
                self.init(named: name) { env, _, args in
                    \(argListAssignedToValues)
                    return Promise<R> {
                        return try await callback(\(argValueList))
                    }
                }
            }

            public convenience init(named name: String, _ callback: @escaping AsyncConvenienceVoidCallback) where Result == Promise<Void> {
                self.init(named: name) { env, this, args in
                    \(argListAssignedToValues)
                    return Promise<Void> {
                        try await callback(\(argValueList))
                    }
                }
            }

            public func napiValue(_ env: napi_env) throws -> napi_value {
                switch value {
                case let .swift(name, callback):
                    return try Self.createFunction(env, named: name) { env, this, args in
                        try callback(env, this, args)
                    }
                case let .javascript(value):
                    return value
                }
            }

            public func call(_ env: napi_env, this: ValueConvertible = Undefined.default\(inGenericsAsArgs)) throws where Result == Undefined {
                let handle = try napiValue(env)

                let args: [napi_value?] = \(paramCount > 0 ? "try [\(inGenericsAsNAPI)]" : "[]")

                try args.withUnsafeBufferPointer { argsBytes in
                    try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, nil)
                }.throwIfError()
            }

            public func call(_ env: napi_env, this: ValueConvertible = Undefined.default\(inGenericsAsArgs)) throws -> Result {
                let handle = try napiValue(env)

                let args: [napi_value?] = \(paramCount > 0 ? "try [\(inGenericsAsNAPI)]" : "[]")

                var result: napi_value?
                try args.withUnsafeBufferPointer { argsBytes in
                    try napi_call_function(env, this.napiValue(env), handle, args.count, argsBytes.baseAddress, &result)
                }.throwIfError()

                return try Result(env, from: result!)
            }

            private static func createFunction(_ env: napi_env, named name: String, _ callback: @escaping TypedFunctionCallback) throws -> napi_value {
                var result: napi_value?
                let nameData = name.data(using: .utf8)!

                let data = TypedFunctionCallbackData(callback: callback, argCount: \(paramCount))
                let unmanagedData = Unmanaged.passRetained(data)

                do {
                    try nameData.withUnsafeBytes {
                        napi_create_function(env, $0.baseAddress?.assumingMemoryBound(to: UInt8.self), $0.count, newNAPICallback,  unmanagedData.toOpaque(), &result)
                    }.throwIfError()
                } catch {
                    unmanagedData.release()
                    throw error
                }

                return result!
            }
            """)
        }
    }
}
