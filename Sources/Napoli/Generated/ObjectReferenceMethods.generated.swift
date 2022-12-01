// swiftformat:disable opaqueGenericParameters

import Foundation
import NAPIC

// 9 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try get(env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    @available(*, noasync)
    func call<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try get(env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    @available(*, noasync)
    func callSelf<P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction9<Undefined, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try get(env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    @available(*, noasync)
    func call<P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction9<Undefined, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try get(env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    func callSelf<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        let function: ThreadsafeTypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try await get(name)
        return try await function.call(this: self, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    func call<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        let function: ThreadsafeTypedFunction9<Result, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try await get(name)
        return try await function.call(this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    func callSelf<P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        let function: ThreadsafeTypedFunction9<Undefined, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try await get(name)
        try await function.call(this: self, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }

    func call<P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible, P8: ValueConvertible {
        let function: ThreadsafeTypedFunction9<Undefined, P0, P1, P2, P3, P4, P5, P6, P7, P8> = try await get(name)
        try await function.call(this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7, p8)
    }
}

// 8 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7> = try get(env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    @available(*, noasync)
    func call<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7> = try get(env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    @available(*, noasync)
    func callSelf<P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction8<Undefined, P0, P1, P2, P3, P4, P5, P6, P7> = try get(env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    @available(*, noasync)
    func call<P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction8<Undefined, P0, P1, P2, P3, P4, P5, P6, P7> = try get(env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    func callSelf<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        let function: ThreadsafeTypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7> = try await get(name)
        return try await function.call(this: self, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    func call<Result, P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        let function: ThreadsafeTypedFunction8<Result, P0, P1, P2, P3, P4, P5, P6, P7> = try await get(name)
        return try await function.call(this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    func callSelf<P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        let function: ThreadsafeTypedFunction8<Undefined, P0, P1, P2, P3, P4, P5, P6, P7> = try await get(name)
        try await function.call(this: self, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    func call<P0, P1, P2, P3, P4, P5, P6, P7>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        let function: ThreadsafeTypedFunction8<Undefined, P0, P1, P2, P3, P4, P5, P6, P7> = try await get(name)
        try await function.call(this: Undefined.default, p0, p1, p2, p3, p4, p5, p6, p7)
    }
}

// 7 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result, P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6> = try get(env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6)
    }

    @available(*, noasync)
    func call<Result, P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6> = try get(env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6)
    }

    @available(*, noasync)
    func callSelf<P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction7<Undefined, P0, P1, P2, P3, P4, P5, P6> = try get(env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4, p5, p6)
    }

    @available(*, noasync)
    func call<P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction7<Undefined, P0, P1, P2, P3, P4, P5, P6> = try get(env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5, p6)
    }

    func callSelf<Result, P0, P1, P2, P3, P4, P5, P6>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        let function: ThreadsafeTypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6> = try await get(name)
        return try await function.call(this: self, p0, p1, p2, p3, p4, p5, p6)
    }

    func call<Result, P0, P1, P2, P3, P4, P5, P6>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        let function: ThreadsafeTypedFunction7<Result, P0, P1, P2, P3, P4, P5, P6> = try await get(name)
        return try await function.call(this: Undefined.default, p0, p1, p2, p3, p4, p5, p6)
    }

    func callSelf<P0, P1, P2, P3, P4, P5, P6>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        let function: ThreadsafeTypedFunction7<Undefined, P0, P1, P2, P3, P4, P5, P6> = try await get(name)
        try await function.call(this: self, p0, p1, p2, p3, p4, p5, p6)
    }

    func call<P0, P1, P2, P3, P4, P5, P6>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        let function: ThreadsafeTypedFunction7<Undefined, P0, P1, P2, P3, P4, P5, P6> = try await get(name)
        try await function.call(this: Undefined.default, p0, p1, p2, p3, p4, p5, p6)
    }
}

// 6 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result, P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction6<Result, P0, P1, P2, P3, P4, P5> = try get(env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4, p5)
    }

    @available(*, noasync)
    func call<Result, P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction6<Result, P0, P1, P2, P3, P4, P5> = try get(env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5)
    }

    @available(*, noasync)
    func callSelf<P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction6<Undefined, P0, P1, P2, P3, P4, P5> = try get(env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4, p5)
    }

    @available(*, noasync)
    func call<P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction6<Undefined, P0, P1, P2, P3, P4, P5> = try get(env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4, p5)
    }

    func callSelf<Result, P0, P1, P2, P3, P4, P5>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        let function: ThreadsafeTypedFunction6<Result, P0, P1, P2, P3, P4, P5> = try await get(name)
        return try await function.call(this: self, p0, p1, p2, p3, p4, p5)
    }

    func call<Result, P0, P1, P2, P3, P4, P5>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        let function: ThreadsafeTypedFunction6<Result, P0, P1, P2, P3, P4, P5> = try await get(name)
        return try await function.call(this: Undefined.default, p0, p1, p2, p3, p4, p5)
    }

    func callSelf<P0, P1, P2, P3, P4, P5>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        let function: ThreadsafeTypedFunction6<Undefined, P0, P1, P2, P3, P4, P5> = try await get(name)
        try await function.call(this: self, p0, p1, p2, p3, p4, p5)
    }

    func call<P0, P1, P2, P3, P4, P5>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        let function: ThreadsafeTypedFunction6<Undefined, P0, P1, P2, P3, P4, P5> = try await get(name)
        try await function.call(this: Undefined.default, p0, p1, p2, p3, p4, p5)
    }
}

// 5 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result, P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction5<Result, P0, P1, P2, P3, P4> = try get(env, name)
        return try function.call(env, this: self, p0, p1, p2, p3, p4)
    }

    @available(*, noasync)
    func call<Result, P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction5<Result, P0, P1, P2, P3, P4> = try get(env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4)
    }

    @available(*, noasync)
    func callSelf<P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction5<Undefined, P0, P1, P2, P3, P4> = try get(env, name)
        try function.call(env, this: self, p0, p1, p2, p3, p4)
    }

    @available(*, noasync)
    func call<P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction5<Undefined, P0, P1, P2, P3, P4> = try get(env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3, p4)
    }

    func callSelf<Result, P0, P1, P2, P3, P4>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        let function: ThreadsafeTypedFunction5<Result, P0, P1, P2, P3, P4> = try await get(name)
        return try await function.call(this: self, p0, p1, p2, p3, p4)
    }

    func call<Result, P0, P1, P2, P3, P4>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        let function: ThreadsafeTypedFunction5<Result, P0, P1, P2, P3, P4> = try await get(name)
        return try await function.call(this: Undefined.default, p0, p1, p2, p3, p4)
    }

    func callSelf<P0, P1, P2, P3, P4>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        let function: ThreadsafeTypedFunction5<Undefined, P0, P1, P2, P3, P4> = try await get(name)
        try await function.call(this: self, p0, p1, p2, p3, p4)
    }

    func call<P0, P1, P2, P3, P4>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        let function: ThreadsafeTypedFunction5<Undefined, P0, P1, P2, P3, P4> = try await get(name)
        try await function.call(this: Undefined.default, p0, p1, p2, p3, p4)
    }
}

// 4 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result, P0, P1, P2, P3>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction4<Result, P0, P1, P2, P3> = try get(env, name)
        return try function.call(env, this: self, p0, p1, p2, p3)
    }

    @available(*, noasync)
    func call<Result, P0, P1, P2, P3>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction4<Result, P0, P1, P2, P3> = try get(env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2, p3)
    }

    @available(*, noasync)
    func callSelf<P0, P1, P2, P3>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction4<Undefined, P0, P1, P2, P3> = try get(env, name)
        try function.call(env, this: self, p0, p1, p2, p3)
    }

    @available(*, noasync)
    func call<P0, P1, P2, P3>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction4<Undefined, P0, P1, P2, P3> = try get(env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2, p3)
    }

    func callSelf<Result, P0, P1, P2, P3>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        let function: ThreadsafeTypedFunction4<Result, P0, P1, P2, P3> = try await get(name)
        return try await function.call(this: self, p0, p1, p2, p3)
    }

    func call<Result, P0, P1, P2, P3>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        let function: ThreadsafeTypedFunction4<Result, P0, P1, P2, P3> = try await get(name)
        return try await function.call(this: Undefined.default, p0, p1, p2, p3)
    }

    func callSelf<P0, P1, P2, P3>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        let function: ThreadsafeTypedFunction4<Undefined, P0, P1, P2, P3> = try await get(name)
        try await function.call(this: self, p0, p1, p2, p3)
    }

    func call<P0, P1, P2, P3>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        let function: ThreadsafeTypedFunction4<Undefined, P0, P1, P2, P3> = try await get(name)
        try await function.call(this: Undefined.default, p0, p1, p2, p3)
    }
}

// 3 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result, P0, P1, P2>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction3<Result, P0, P1, P2> = try get(env, name)
        return try function.call(env, this: self, p0, p1, p2)
    }

    @available(*, noasync)
    func call<Result, P0, P1, P2>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction3<Result, P0, P1, P2> = try get(env, name)
        return try function.call(env, this: Undefined.default, p0, p1, p2)
    }

    @available(*, noasync)
    func callSelf<P0, P1, P2>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction3<Undefined, P0, P1, P2> = try get(env, name)
        try function.call(env, this: self, p0, p1, p2)
    }

    @available(*, noasync)
    func call<P0, P1, P2>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1, _ p2: P2) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction3<Undefined, P0, P1, P2> = try get(env, name)
        try function.call(env, this: Undefined.default, p0, p1, p2)
    }

    func callSelf<Result, P0, P1, P2>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        let function: ThreadsafeTypedFunction3<Result, P0, P1, P2> = try await get(name)
        return try await function.call(this: self, p0, p1, p2)
    }

    func call<Result, P0, P1, P2>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        let function: ThreadsafeTypedFunction3<Result, P0, P1, P2> = try await get(name)
        return try await function.call(this: Undefined.default, p0, p1, p2)
    }

    func callSelf<P0, P1, P2>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        let function: ThreadsafeTypedFunction3<Undefined, P0, P1, P2> = try await get(name)
        try await function.call(this: self, p0, p1, p2)
    }

    func call<P0, P1, P2>(_ name: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        let function: ThreadsafeTypedFunction3<Undefined, P0, P1, P2> = try await get(name)
        try await function.call(this: Undefined.default, p0, p1, p2)
    }
}

// 2 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result, P0, P1>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction2<Result, P0, P1> = try get(env, name)
        return try function.call(env, this: self, p0, p1)
    }

    @available(*, noasync)
    func call<Result, P0, P1>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1) throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction2<Result, P0, P1> = try get(env, name)
        return try function.call(env, this: Undefined.default, p0, p1)
    }

    @available(*, noasync)
    func callSelf<P0, P1>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1) throws where P0: ValueConvertible, P1: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction2<Undefined, P0, P1> = try get(env, name)
        try function.call(env, this: self, p0, p1)
    }

    @available(*, noasync)
    func call<P0, P1>(_ env: Environment? = nil, _ name: String, _ p0: P0, _ p1: P1) throws where P0: ValueConvertible, P1: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction2<Undefined, P0, P1> = try get(env, name)
        try function.call(env, this: Undefined.default, p0, p1)
    }

    func callSelf<Result, P0, P1>(_ name: String, _ p0: P0, _ p1: P1) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
        let function: ThreadsafeTypedFunction2<Result, P0, P1> = try await get(name)
        return try await function.call(this: self, p0, p1)
    }

    func call<Result, P0, P1>(_ name: String, _ p0: P0, _ p1: P1) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible {
        let function: ThreadsafeTypedFunction2<Result, P0, P1> = try await get(name)
        return try await function.call(this: Undefined.default, p0, p1)
    }

    func callSelf<P0, P1>(_ name: String, _ p0: P0, _ p1: P1) async throws where P0: ValueConvertible, P1: ValueConvertible {
        let function: ThreadsafeTypedFunction2<Undefined, P0, P1> = try await get(name)
        try await function.call(this: self, p0, p1)
    }

    func call<P0, P1>(_ name: String, _ p0: P0, _ p1: P1) async throws where P0: ValueConvertible, P1: ValueConvertible {
        let function: ThreadsafeTypedFunction2<Undefined, P0, P1> = try await get(name)
        try await function.call(this: Undefined.default, p0, p1)
    }
}

// 1 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result, P0>(_ env: Environment? = nil, _ name: String, _ p0: P0) throws -> Result where Result: ValueConvertible, P0: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction1<Result, P0> = try get(env, name)
        return try function.call(env, this: self, p0)
    }

    @available(*, noasync)
    func call<Result, P0>(_ env: Environment? = nil, _ name: String, _ p0: P0) throws -> Result where Result: ValueConvertible, P0: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction1<Result, P0> = try get(env, name)
        return try function.call(env, this: Undefined.default, p0)
    }

    @available(*, noasync)
    func callSelf<P0>(_ env: Environment? = nil, _ name: String, _ p0: P0) throws where P0: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction1<Undefined, P0> = try get(env, name)
        try function.call(env, this: self, p0)
    }

    @available(*, noasync)
    func call<P0>(_ env: Environment? = nil, _ name: String, _ p0: P0) throws where P0: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction1<Undefined, P0> = try get(env, name)
        try function.call(env, this: Undefined.default, p0)
    }

    func callSelf<Result, P0>(_ name: String, _ p0: P0) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible {
        let function: ThreadsafeTypedFunction1<Result, P0> = try await get(name)
        return try await function.call(this: self, p0)
    }

    func call<Result, P0>(_ name: String, _ p0: P0) async throws -> Result where Result: ValueConvertible, P0: ValueConvertible {
        let function: ThreadsafeTypedFunction1<Result, P0> = try await get(name)
        return try await function.call(this: Undefined.default, p0)
    }

    func callSelf<P0>(_ name: String, _ p0: P0) async throws where P0: ValueConvertible {
        let function: ThreadsafeTypedFunction1<Undefined, P0> = try await get(name)
        try await function.call(this: self, p0)
    }

    func call<P0>(_ name: String, _ p0: P0) async throws where P0: ValueConvertible {
        let function: ThreadsafeTypedFunction1<Undefined, P0> = try await get(name)
        try await function.call(this: Undefined.default, p0)
    }
}

// 0 param methods
public extension ObjectReference {
    @available(*, noasync)
    func callSelf<Result>(_ env: Environment? = nil, _ name: String) throws -> Result where Result: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction0<Result> = try get(env, name)
        return try function.call(env, this: self)
    }

    @available(*, noasync)
    func call<Result>(_ env: Environment? = nil, _ name: String) throws -> Result where Result: ValueConvertible {
        let env = env ?? storedEnvironment
        let function: TypedFunction0<Result> = try get(env, name)
        return try function.call(env, this: Undefined.default)
    }

    @available(*, noasync)
    func callSelf(_ env: Environment? = nil, _ name: String) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction0<Undefined> = try get(env, name)
        try function.call(env, this: self)
    }

    @available(*, noasync)
    func call(_ env: Environment? = nil, _ name: String) throws {
        let env = env ?? storedEnvironment
        let function: TypedFunction0<Undefined> = try get(env, name)
        try function.call(env, this: Undefined.default)
    }

    func callSelf<Result>(_ name: String) async throws -> Result where Result: ValueConvertible {
        let function: ThreadsafeTypedFunction0<Result> = try await get(name)
        return try await function.call(this: self)
    }

    func call<Result>(_ name: String) async throws -> Result where Result: ValueConvertible {
        let function: ThreadsafeTypedFunction0<Result> = try await get(name)
        return try await function.call(this: Undefined.default)
    }

    func callSelf(_ name: String) async throws {
        let function: ThreadsafeTypedFunction0<Undefined> = try await get(name)
        try await function.call(this: self)
    }

    func call(_ name: String) async throws {
        let function: ThreadsafeTypedFunction0<Undefined> = try await get(name)
        try await function.call(this: Undefined.default)
    }
}
