import Foundation

enum EventEmitter {
    static func generate(maxParams: Int) throws -> Source {
        var source = Source()
        source.add("""
        // swiftformat:disable opaqueGenericParameters

        import Foundation
        import NAPIC

        public class EventEmitter: ObjectReference {
            func removeAllListeners(_ event: String? = nil) {
                if let event {

                } else {

                }
            }
        }
        """)
        source.newline()

        for i in (0 ..< (maxParams - 1)).reversed() {
            try generateExtension(source: &source, paramCount: i)
        }

        return source
    }

    static func generateExtension(source: inout Source, paramCount: Int) throws {
        let inGenerics = [Generic](prefix: "P", count: paramCount)

        let commaSeparatedInGenerics = inGenerics.map(\.type).commaSeparated

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
        public extension EventEmitter {
            @available(*, noasync)
            func on\(inGenerics.bracketedOrNone)(_ env: Environment? = nil, _ event: String, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Void) throws\(wheres.backspaceIfNotEmpty()) {
                try callSelf(env, "on", event, TypedFunction\(paramCount)(named: "on", callback))
            }

            @available(*, noasync)
            func on\(inGenerics.bracketedOrNone)(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Void) throws\(wheres.backspaceIfNotEmpty()) {
                try callSelf(env, "on", event, TypedFunction\(paramCount)(named: "on", callback))
            }

            @available(*, noasync)
            func on\(inGenerics.bracketedOrNone)(_ env: Environment? = nil, _ event: String, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Void) throws\(wheres.backspaceIfNotEmpty()) {
                try callSelf(env, "on", event, TypedFunction\(paramCount)(named: "on", callback))
            }

            func on\(inGenerics.bracketedOrNone)(_ event: String, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Void) async throws\(wheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.on(env, event, callback) }
            }

            func on\(inGenerics.bracketedOrNone)(_ event: String, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Void) async throws\(wheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.on(env, event, callback) }
            }

            func on\(inGenerics.bracketedOrNone)(_ event: String, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Void) async throws\(wheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.on(env, event, callback) }
            }

            @available(*, noasync)
            func once\(inGenerics.bracketedOrNone)(_ env: Environment? = nil, _ event: String, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Void) throws\(wheres.backspaceIfNotEmpty()) {
                try callSelf(env, "once", event, TypedFunction\(paramCount)(named: "once", callback))
            }

            @available(*, noasync)
            func once\(inGenerics.bracketedOrNone)(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Void) throws\(wheres.backspaceIfNotEmpty()) {
                try callSelf(env, "once", event, TypedFunction\(paramCount)(named: "once", callback))
            }

            @available(*, noasync)
            func once\(inGenerics.bracketedOrNone)(_ env: Environment? = nil, _ event: String, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Void) throws\(wheres.backspaceIfNotEmpty()) {
                try callSelf(env, "once", event, TypedFunction\(paramCount)(named: "once", callback))
            }

            func once\(inGenerics.bracketedOrNone)(_ event: String, _ callback: @escaping (\(commaSeparatedInGenerics)) throws -> Void) async throws\(wheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.once(env, event, callback) }
            }

            func once\(inGenerics.bracketedOrNone)(_ event: String, _ callback: @escaping (Environment\(commaSeparatedInGenerics.prefixCommaIfNotEmpty())) throws -> Void) async throws\(wheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.once(env, event, callback) }
            }

            func once\(inGenerics.bracketedOrNone)(_ event: String, _ callback: @escaping (\(commaSeparatedInGenerics)) async throws -> Void) async throws\(wheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.once(env, event, callback) }
            }

            @available(*, noasync)
            func emit\(inGenerics.bracketedOrNone)(_ env: Environment? = nil, _ event: String\(inGenericsAsArgs)) throws\(wheres.backspaceIfNotEmpty()) {
                try callSelf(env, "emit", event\(argValueList))
            }

            func emit\(inGenerics.bracketedOrNone)(_ event: String\(inGenericsAsArgs)) async throws\(wheres.backspaceIfNotEmpty()) {
                try await withEnvironment { env in try self.emit(env, event\(argValueList)) }
            }
        }
        """)
    }
}
