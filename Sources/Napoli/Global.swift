import Foundation
import NAPIC

public extension Environment {
    final class Global: ObjectReference {
        @available(*, noasync)
        fileprivate convenience init(_ env: Environment) throws {
            var global: napi_value?
            try napi_get_global(env.env, &global).throwIfError()
            try self.init(env, from: global!)
        }
    }

    @available(*, noasync)
    func global() throws -> Global {
        try Global(self)
    }
}

public extension Environment.Global {
    final class JSON: ObjectReference {
        @available(*, noasync)
        public func stringify(env: Environment? = nil, _ value: some ValueConvertible) throws -> String {
            try call(env: env, "stringify", value)
        }

        @available(*, noasync)
        public func parse<V: ValueConvertible>(env: Environment? = nil, _ string: String) throws -> V {
            try call(env: env, "parse", string)
        }
    }

    @available(*, noasync)
    func json(env: Environment? = nil) throws -> JSON {
        try get(env: env, "JSON")
    }
}
