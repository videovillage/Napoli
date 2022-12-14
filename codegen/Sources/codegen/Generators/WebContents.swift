import Foundation

enum WebContents {
    static func generate(maxParams: Int) throws -> Source {
        var source = Source()
        source.add("""
        // swiftformat:disable opaqueGenericParameters

        import Foundation
        import NAPIC

        public class WebContents: EventEmitter {}
        """)
        source.newline()

        for i in (0 ..< (maxParams - 1)).reversed() {
            try generateExtension(source: &source, paramCount: i)
        }

        return source
    }

    static func generateExtension(source: inout Source, paramCount: Int) throws {
        let inGenerics = [Generic](prefix: "P", count: paramCount)

        let wheres = inGenerics.conforming(to: Types.valueConvertible).value

        let argValueList = inGenerics.map { $0.type.lowercased() }.commaSeparated.prefixCommaIfNotEmpty()

        let inGenericsAsArgs: String
        if paramCount > 0 {
            inGenericsAsArgs = ", " + inGenerics.map { "_ \($0.type.lowercased()): \($0.type)" }.commaSeparated
        } else {
            inGenericsAsArgs = ""
        }

        source.add("""
        // \(paramCount) param methods
        public extension WebContents {
            @available(*, noasync)
            func send\(inGenerics.bracketedOrNone)(env: Environment? = nil, _ channel: String\(inGenericsAsArgs)) throws\(wheres.backspaceIfNotEmpty()) {
                try callSelf(env: env, "send", channel\(argValueList))
            }

            func send\(inGenerics.bracketedOrNone)(_ channel: String\(inGenericsAsArgs)) async throws\(wheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.send(env: env, channel\(argValueList)) }
            }
        }
        """)
    }
}
