// swiftformat:disable opaqueGenericParameters

import Foundation
import NAPIC

/// 9 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try get(env: env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try get(env: env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    @available(*, noasync)
    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction9<Undefined, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try get(env: env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    @available(*, noasync)
    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction9<Undefined, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try get(env: env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4, p5, p6, p7, p8) }
    }

    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4, p5, p6, p7, p8) }
    }

    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4, p5, p6, p7, p8) }
    }

    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4, p5, p6, p7, p8) }
    }
}

/// 8 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7> = try get(env: env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7> = try get(env: env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    @available(*, noasync)
    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction8<Undefined, P0, P1, P2, P3, P4, P5, P6, P7> = try get(env: env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    @available(*, noasync)
    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction8<Undefined, P0, P1, P2, P3, P4, P5, P6, P7> = try get(env: env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4, p5, p6, p7) }
    }

    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4, p5, p6, p7) }
    }

    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4, p5, p6, p7) }
    }

    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4, p5, p6, p7) }
    }
}

/// 7 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6> = try get(env: env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6> = try get(env: env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6)
    }

    @available(*, noasync)
    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction7<Undefined, P0, P1, P2, P3, P4, P5, P6> = try get(env: env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6)
    }

    @available(*, noasync)
    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction7<Undefined, P0, P1, P2, P3, P4, P5, P6> = try get(env: env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6)
    }

    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4, p5, p6) }
    }

    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4, p5, p6) }
    }

    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4, p5, p6) }
    }

    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4, p5, p6) }
    }
}

/// 6 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction6<Result, P0, P1, P2, P3, P4, P5> = try get(env: env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4, p5)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction6<Result, P0, P1, P2, P3, P4, P5> = try get(env: env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5)
    }

    @available(*, noasync)
    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction6<Undefined, P0, P1, P2, P3, P4, P5> = try get(env: env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4, p5)
    }

    @available(*, noasync)
    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction6<Undefined, P0, P1, P2, P3, P4, P5> = try get(env: env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5)
    }

    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4, p5) }
    }

    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4, p5) }
    }

    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4, p5) }
    }

    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4, p5) }
    }
}

/// 5 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction5<Result, P0, P1, P2, P3, P4> = try get(env: env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction5<Result, P0, P1, P2, P3, P4> = try get(env: env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4)
    }

    @available(*, noasync)
    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction5<Undefined, P0, P1, P2, P3, P4> = try get(env: env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4)
    }

    @available(*, noasync)
    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction5<Undefined, P0, P1, P2, P3, P4> = try get(env: env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4)
    }

    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4) }
    }

    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4) }
    }

    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3, p4) }
    }

    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3, p4) }
    }
}

/// 4 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction4<Result, P0, P1, P2, P3> = try get(env: env, name)
        return try function.call(env, this: self, p0, p1, p2, p3)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction4<Result, P0, P1, P2, P3> = try get(env: env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3)
    }

    @available(*, noasync)
    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction4<Undefined, P0, P1, P2, P3> = try get(env: env, name)
        try function.call(env, this: self, p0, p1, p2, p3)
    }

    @available(*, noasync)
    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction4<Undefined, P0, P1, P2, P3> = try get(env: env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3)
    }

    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3) }
    }

    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3) }
    }

    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2, p3) }
    }

    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2, p3) }
    }
}

/// 3 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction3<Result, P0, P1, P2> = try get(env: env, name)
        return try function.call(env, this: self, p0, p1, p2)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction3<Result, P0, P1, P2> = try get(env: env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2)
    }

    @available(*, noasync)
    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction3<Undefined, P0, P1, P2> = try get(env: env, name)
        try function.call(env, this: self, p0, p1, p2)
    }

    @available(*, noasync)
    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction3<Undefined, P0, P1, P2> = try get(env: env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2)
    }

    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2) }
    }

    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2) }
    }

    func callSelf<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1, p2) }
    }

    func call<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1, p2) }
    }
}

/// 2 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction2<Result, P0, P1> = try get(env: env, name)
        return try function.call(env, this: self, p0, p1)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction2<Result, P0, P1> = try get(env: env, name)
        return try function.call(env, this: Undefined.default, p0, p1)
    }

    @available(*, noasync)
    func callSelf<P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction2<Undefined, P0, P1> = try get(env: env, name)
        try function.call(env, this: self, p0, p1)
    }

    @available(*, noasync)
    func call<P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction2<Undefined, P0, P1> = try get(env: env, name)
        try function.call(env, this: Undefined.default, p0, p1)
    }

    func callSelf<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1) }
    }

    func call<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1) }
    }

    func callSelf<P0: ValueConvertible, P1: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0, p1) }
    }

    func call<P0: ValueConvertible, P1: ValueConvertible>(_ name: String, _ p0: P0, _ p1: P1) async throws {
        try await withEnvironment { env in try self.call(env: env, name, p0, p1) }
    }
}

/// 1 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible, P0: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction1<Result, P0> = try get(env: env, name)
        return try function.call(env, this: self, p0)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible, P0: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction1<Result, P0> = try get(env: env, name)
        return try function.call(env, this: Undefined.default, p0)
    }

    @available(*, noasync)
    func callSelf<P0: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction1<Undefined, P0> = try get(env: env, name)
        try function.call(env, this: self, p0)
    }

    @available(*, noasync)
    func call<P0: ValueConvertible>(env: Environment? = nil, _ name: String, _ p0: P0) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction1<Undefined, P0> = try get(env: env, name)
        try function.call(env, this: Undefined.default, p0)
    }

    func callSelf<Result: ValueConvertible, P0: ValueConvertible>(_ name: String, _ p0: P0) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0) }
    }

    func call<Result: ValueConvertible, P0: ValueConvertible>(_ name: String, _ p0: P0) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name, p0) }
    }

    func callSelf<P0: ValueConvertible>(_ name: String, _ p0: P0) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name, p0) }
    }

    func call<P0: ValueConvertible>(_ name: String, _ p0: P0) async throws {
        try await withEnvironment { env in try self.call(env: env, name, p0) }
    }
}

/// 0 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result: ValueConvertible>(env: Environment? = nil, _ name: String) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction0<Result> = try get(env: env, name)
        return try function.call(env, this: self)
    }

    @available(*, noasync)
    func call<Result: ValueConvertible>(env: Environment? = nil, _ name: String) throws -> Result {
        let env = env ?? storedEnvironment
        let function: TypedFunction0<Result> = try get(env: env, name)
        return try function.call(env, this: Undefined.default)
    }

    @available(*, noasync)
    func callSelf(env: Environment? = nil, _ name: String) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction0<Undefined> = try get(env: env, name)
        try function.call(env, this: self)
    }

    @available(*, noasync)
    func call(env: Environment? = nil, _ name: String) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction0<Undefined> = try get(env: env, name)
        try function.call(env, this: Undefined.default)
    }

    func callSelf<Result: ValueConvertible>(_ name: String) async throws -> Result {
        try await withEnvironment { env in try self.callSelf(env: env, name) }
    }

    func call<Result: ValueConvertible>(_ name: String) async throws -> Result {
        try await withEnvironment { env in try self.call(env: env, name) }
    }

    func callSelf(_ name: String) async throws {
        try await withEnvironment { env in try self.callSelf(env: env, name) }
    }

    func call(_ name: String) async throws {
        try await withEnvironment { env in try self.call(env: env, name) }
    }
}
