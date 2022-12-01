import Foundation

enum ObjectReferenceMethods {
    static func generate(maxParams: Int) throws -> Source {
        var source = Source()
        source.add("""
        // swiftformat:disable opaqueGenericParameters

        import Foundation
        import NAPIC
        """)
        source.newline()

        for i in (0 ..< maxParams).reversed() {
            try generateExtension(source: &source, paramCount: i)
        }

        return source
    }

    static func generateExtension(source: inout Source, paramCount: Int) throws {
        let resultGeneric = Generic(type: "Result")
        let inGenerics = [Generic](prefix: "P", count: paramCount)
        let allGenerics = [resultGeneric] + inGenerics
        let allWheres = allGenerics.conforming(to: Types.valueConvertible).value
        let inWheres = inGenerics.conforming(to: Types.valueConvertible).value

        let commaSeparatedInGenerics = inGenerics.map(\.type).commaSeparated

        let inGenericsAsArgs: String
        if paramCount > 0 {
            inGenericsAsArgs = ", " + inGenerics.map { "_ \($0.type.lowercased()): \($0.type)" }.commaSeparated
        } else {
            inGenericsAsArgs = ""
        }

        let inGenericsAsCallArgs = inGenerics.map { $0.type.lowercased() }.commaSeparated.prefixCommaIfNotEmpty()

        source.add("""
            // \(paramCount) param methods
            public extension ObjectReference {
                @available(*, noasync)
                func callSelf\(allGenerics.bracketedOrNone)(_ env: Environment? = nil, _ name: String\(inGenericsAsArgs)) throws -> Result\(allWheres.backspaceIfNotEmpty()) {
                    let env = env ?? storedEnvironment
                    let function: TypedFunction\(paramCount)\(allGenerics.bracketedOrNone) = try get(env, name)
                    return try function.call(env, this: self\(inGenericsAsCallArgs))
                }

                @available(*, noasync)
                func call\(allGenerics.bracketedOrNone)(_ env: Environment? = nil, _ name: String\(inGenericsAsArgs)) throws -> Result\(allWheres.backspaceIfNotEmpty()) {
                    let env = env ?? storedEnvironment
                    let function: TypedFunction\(paramCount)\(allGenerics.bracketedOrNone) = try get(env, name)
                    return try function.call(env, this: Undefined.default\(inGenericsAsCallArgs))
                }

                @available(*, noasync)
                func callSelf\(inGenerics.bracketedOrNone)(_ env: Environment? = nil, _ name: String\(inGenericsAsArgs)) throws \(inWheres.backspaceIfNotEmpty()) {
                    let env = env ?? storedEnvironment
                    let function: TypedFunction\(paramCount)<Undefined\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())> = try get(env, name)
                    try function.call(env, this: self\(inGenericsAsCallArgs))
                }

                @available(*, noasync)
                func call\(inGenerics.bracketedOrNone)(_ env: Environment? = nil, _ name: String\(inGenericsAsArgs)) throws \(inWheres.backspaceIfNotEmpty()) {
                    let env = env ?? storedEnvironment
                    let function: TypedFunction\(paramCount)<Undefined\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())> = try get(env, name)
                    try function.call(env, this: Undefined.default\(inGenericsAsCallArgs))
                }

                func callSelf\(allGenerics.bracketedOrNone)(_ name: String\(inGenericsAsArgs)) async throws -> Result\(allWheres.backspaceIfNotEmpty()) {
                    try await withEnvironment { env in try self.callSelf(env, name\(inGenericsAsCallArgs)) }
                }

                func call\(allGenerics.bracketedOrNone)(_ name: String\(inGenericsAsArgs)) async throws -> Result\(allWheres.backspaceIfNotEmpty()) {
                    try await withEnvironment { env in try self.call(env, name\(inGenericsAsCallArgs)) }
                }

                func callSelf\(inGenerics.bracketedOrNone)(_ name: String\(inGenericsAsArgs)) async throws \(inWheres.backspaceIfNotEmpty()) {
                    try await withEnvironment { env in try self.callSelf(env, name\(inGenericsAsCallArgs)) }
                }

                func call\(inGenerics.bracketedOrNone)(_ name: String\(inGenericsAsArgs)) async throws \(inWheres.backspaceIfNotEmpty()) {
                    try await withEnvironment { env in try self.call(env, name\(inGenericsAsCallArgs)) }
                }
            }
        """)
    }
}
