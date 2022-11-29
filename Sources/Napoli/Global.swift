import Foundation
import NAPIC

public extension Environment {
    final class Global: ObjectReference {
        public convenience init(_ env: Environment) throws {
            var global: napi_value?
            try napi_get_global(env.env, &global).throwIfError()
            try self.init(env, from: global!)
        }
    }

    func global() throws -> Global {
        try Global(self)
    }
}

public extension Environment.Global {
    final class JSON: ObjectReference {
        public func stringify<V: ValueConvertible>(_ value: V) throws -> String {
            let function: TypedFunction1<String, V> = try get(storedEnvironment, "stringify")
            return try function.call(storedEnvironment, value)
        }

        public func parse<V: ValueConvertible>(_ string: String) throws -> V {
            let function: TypedFunction1<V, String> = try get(storedEnvironment, "parse")
            return try function.call(storedEnvironment, string)
        }
    }

    func json() throws -> JSON {
        try get(storedEnvironment, "JSON")
    }
}
