import Foundation

enum IPCMain {
    static func generate(maxParams: Int) throws -> Source {
        var source = Source()
        source.add("""
        // swiftformat:disable opaqueGenericParameters

        import Foundation
        import NAPIC

        public class IPCMain: EventEmitter {}
        """)
        source.newline()

        for i in (0 ..< (maxParams - 1)).reversed() {
            try generateExtension(source: &source, paramCount: i)
        }

        return source
    }

    static func generateExtension(source: inout Source, paramCount: Int) throws {
        let inGenerics = [Generic](prefix: "P", count: paramCount)
        let allGenerics = [Generic(type: "Result")] + inGenerics

        let commaSeparatedInGenerics = inGenerics.map(\.type).commaSeparated

        let allWheres = allGenerics.conforming(to: Types.valueConvertible).value

        source.add("""
        // \(paramCount) param methods
        public extension IPCMain {
            @available(*, noasync)
            func handle\(allGenerics.bracketedOrNone)(_ env: Environment? = nil, _ channel: String, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Result) throws\(allWheres.backspaceIfNotEmpty()) {
                try callSelf(env, "handle", channel, TypedFunction\(paramCount)(named: "handle", callback))
            }

            @available(*, noasync)
            func handle\(allGenerics.bracketedOrNone)(_ env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Result) throws\(allWheres.backspaceIfNotEmpty()) {
                try callSelf(env, "handle", channel, TypedFunction\(paramCount)(named: "handle", callback))
            }

            @available(*, noasync)
            func handle\(allGenerics.bracketedOrNone)(_ env: Environment? = nil, _ channel: String, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Result) throws\(allWheres.backspaceIfNotEmpty()) {
                try callSelf(env, "handle", channel, TypedFunction\(paramCount)(named: "handle", callback))
            }

            func handle\(allGenerics.bracketedOrNone)(_ channel: String, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Result) async throws\(allWheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.handle(env, channel, callback) }
            }

            func handle\(allGenerics.bracketedOrNone)(_ channel: String, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Result) async throws\(allWheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.handle(env, channel, callback) }
            }

            func handle\(allGenerics.bracketedOrNone)(_ channel: String, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Result) async throws\(allWheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.handle(env, channel, callback) }
            }

            @available(*, noasync)
            func handleOnce\(allGenerics.bracketedOrNone)(_ env: Environment? = nil, _ channel: String, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Result) throws\(allWheres.backspaceIfNotEmpty()) {
                try callSelf(env, "handleOnce", channel, TypedFunction\(paramCount)(named: "handleOnce", callback))
            }

            @available(*, noasync)
            func handleOnce\(allGenerics.bracketedOrNone)(_ env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Result) throws\(allWheres.backspaceIfNotEmpty()) {
                try callSelf(env, "handleOnce", channel, TypedFunction\(paramCount)(named: "handleOnce", callback))
            }

            @available(*, noasync)
            func handleOnce\(allGenerics.bracketedOrNone)(_ env: Environment? = nil, _ channel: String, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Result) throws\(allWheres.backspaceIfNotEmpty()) {
                try callSelf(env, "handleOnce", channel, TypedFunction\(paramCount)(named: "handleOnce", callback))
            }

            func handleOnce\(allGenerics.bracketedOrNone)(_ channel: String, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Result) async throws\(allWheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.handleOnce(env, channel, callback) }
            }

            func handleOnce\(allGenerics.bracketedOrNone)(_ channel: String, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Result) async throws\(allWheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.handleOnce(env, channel, callback) }
            }

            func handleOnce\(allGenerics.bracketedOrNone)(_ channel: String, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Result) async throws\(allWheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.handleOnce(env, channel, callback) }
            }
        }
        """)
    }
}
