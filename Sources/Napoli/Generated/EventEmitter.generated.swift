// swiftformat:disable opaqueGenericParameters

import Foundation
import NAPIC

// 8 param methods
public extension EventEmitter {
    @available(*, noasync)
    func on<P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction8(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction8(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction8(named: "on", callback))
    }

    func on<P0, P1, P2, P3, P4, P5, P6, P7>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3, P4, P5, P6, P7>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3, P4, P5, P6, P7>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction8(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction8(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction8(named: "once", callback))
    }

    func once<P0, P1, P2, P3, P4, P5, P6, P7>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3, P4, P5, P6, P7>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3, P4, P5, P6, P7>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    @available(*, noasync)
    func emit<P0, P1, P2, P3, P4, P5, P6, P7>(_ env: Environment? = nil, _ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try callSelf(env, "emit", event, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    func emit<P0, P1, P2, P3, P4, P5, P6, P7>(_ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try await withEnvironment { env in try self.emit(env, event, p0, p1, p2, p3, p4, p5, p6, p7) }
    }
}

// 7 param methods
public extension EventEmitter {
    @available(*, noasync)
    func on<P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction7(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction7(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction7(named: "on", callback))
    }

    func on<P0, P1, P2, P3, P4, P5, P6>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3, P4, P5, P6>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3, P4, P5, P6>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction7(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction7(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction7(named: "once", callback))
    }

    func once<P0, P1, P2, P3, P4, P5, P6>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3, P4, P5, P6>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3, P4, P5, P6>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    @available(*, noasync)
    func emit<P0, P1, P2, P3, P4, P5, P6>(_ env: Environment? = nil, _ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try callSelf(env, "emit", event, p0, p1, p2, p3, p4, p5, p6)
    }

    func emit<P0, P1, P2, P3, P4, P5, P6>(_ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try await withEnvironment { env in try self.emit(env, event, p0, p1, p2, p3, p4, p5, p6) }
    }
}

// 6 param methods
public extension EventEmitter {
    @available(*, noasync)
    func on<P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction6(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction6(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction6(named: "on", callback))
    }

    func on<P0, P1, P2, P3, P4, P5>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3, P4, P5>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3, P4, P5>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction6(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction6(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction6(named: "once", callback))
    }

    func once<P0, P1, P2, P3, P4, P5>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3, P4, P5>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3, P4, P5>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    @available(*, noasync)
    func emit<P0, P1, P2, P3, P4, P5>(_ env: Environment? = nil, _ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try callSelf(env, "emit", event, p0, p1, p2, p3, p4, p5)
    }

    func emit<P0, P1, P2, P3, P4, P5>(_ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try await withEnvironment { env in try self.emit(env, event, p0, p1, p2, p3, p4, p5) }
    }
}

// 5 param methods
public extension EventEmitter {
    @available(*, noasync)
    func on<P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction5(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction5(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction5(named: "on", callback))
    }

    func on<P0, P1, P2, P3, P4>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3, P4>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3, P4>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction5(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction5(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3, P4) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction5(named: "once", callback))
    }

    func once<P0, P1, P2, P3, P4>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3, P4>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3, P4>(_ event: String, _ callback: @escaping (P0, P1, P2, P3, P4) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    @available(*, noasync)
    func emit<P0, P1, P2, P3, P4>(_ env: Environment? = nil, _ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try callSelf(env, "emit", event, p0, p1, p2, p3, p4)
    }

    func emit<P0, P1, P2, P3, P4>(_ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try await withEnvironment { env in try self.emit(env, event, p0, p1, p2, p3, p4) }
    }
}

// 4 param methods
public extension EventEmitter {
    @available(*, noasync)
    func on<P0, P1, P2, P3>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction4(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction4(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2, P3>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction4(named: "on", callback))
    }

    func on<P0, P1, P2, P3>(_ event: String, _ callback: @escaping (P0, P1, P2, P3) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2, P3>(_ event: String, _ callback: @escaping (P0, P1, P2, P3) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction4(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction4(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2, P3>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2, P3) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction4(named: "once", callback))
    }

    func once<P0, P1, P2, P3>(_ event: String, _ callback: @escaping (P0, P1, P2, P3) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2, P3) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2, P3>(_ event: String, _ callback: @escaping (P0, P1, P2, P3) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    @available(*, noasync)
    func emit<P0, P1, P2, P3>(_ env: Environment? = nil, _ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try callSelf(env, "emit", event, p0, p1, p2, p3)
    }

    func emit<P0, P1, P2, P3>(_ event: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try await withEnvironment { env in try self.emit(env, event, p0, p1, p2, p3) }
    }
}

// 3 param methods
public extension EventEmitter {
    @available(*, noasync)
    func on<P0, P1, P2>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction3(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction3(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1, P2>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction3(named: "on", callback))
    }

    func on<P0, P1, P2>(_ event: String, _ callback: @escaping (P0, P1, P2) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1, P2>(_ event: String, _ callback: @escaping (P0, P1, P2) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    @available(*, noasync)
    func once<P0, P1, P2>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction3(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1, P2) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction3(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1, P2>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1, P2) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction3(named: "once", callback))
    }

    func once<P0, P1, P2>(_ event: String, _ callback: @escaping (P0, P1, P2) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2>(_ event: String, _ callback: @escaping (Environment, P0, P1, P2) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1, P2>(_ event: String, _ callback: @escaping (P0, P1, P2) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    @available(*, noasync)
    func emit<P0, P1, P2>(_ env: Environment? = nil, _ event: String, _ p0: P0, _ p1: P1, _ p2: P2) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try callSelf(env, "emit", event, p0, p1, p2)
    }

    func emit<P0, P1, P2>(_ event: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try await withEnvironment { env in try self.emit(env, event, p0, p1, p2) }
    }
}

// 2 param methods
public extension EventEmitter {
    @available(*, noasync)
    func on<P0, P1>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction2(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction2(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0, P1>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction2(named: "on", callback))
    }

    func on<P0, P1>(_ event: String, _ callback: @escaping (P0, P1) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1>(_ event: String, _ callback: @escaping (Environment, P0, P1) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0, P1>(_ event: String, _ callback: @escaping (P0, P1) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    @available(*, noasync)
    func once<P0, P1>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction2(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0, P1) throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction2(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0, P1>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0, P1) async throws -> Void) throws where P0: ValueConvertible, P1: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction2(named: "once", callback))
    }

    func once<P0, P1>(_ event: String, _ callback: @escaping (P0, P1) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1>(_ event: String, _ callback: @escaping (Environment, P0, P1) throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0, P1>(_ event: String, _ callback: @escaping (P0, P1) async throws -> Void) async throws where P0: ValueConvertible, P1: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    @available(*, noasync)
    func emit<P0, P1>(_ env: Environment? = nil, _ event: String, _ p0: P0, _ p1: P1) throws where P0: ValueConvertible, P1: ValueConvertible {
        try callSelf(env, "emit", event, p0, p1)
    }

    func emit<P0, P1>(_ event: String, _ p0: P0, _ p1: P1) async throws where P0: ValueConvertible, P1: ValueConvertible {
        try await withEnvironment { env in try self.emit(env, event, p0, p1) }
    }
}

// 1 param methods
public extension EventEmitter {
    @available(*, noasync)
    func on<P0>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0) throws -> Void) throws where P0: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction1(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0) throws -> Void) throws where P0: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction1(named: "on", callback))
    }

    @available(*, noasync)
    func on<P0>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0) async throws -> Void) throws where P0: ValueConvertible {
        try callSelf(env, "on", event, TypedFunction1(named: "on", callback))
    }

    func on<P0>(_ event: String, _ callback: @escaping (P0) throws -> Void) async throws where P0: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0>(_ event: String, _ callback: @escaping (Environment, P0) throws -> Void) async throws where P0: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on<P0>(_ event: String, _ callback: @escaping (P0) async throws -> Void) async throws where P0: ValueConvertible {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    @available(*, noasync)
    func once<P0>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0) throws -> Void) throws where P0: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction1(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment, P0) throws -> Void) throws where P0: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction1(named: "once", callback))
    }

    @available(*, noasync)
    func once<P0>(_ env: Environment? = nil, _ event: String, _ callback: @escaping (P0) async throws -> Void) throws where P0: ValueConvertible {
        try callSelf(env, "once", event, TypedFunction1(named: "once", callback))
    }

    func once<P0>(_ event: String, _ callback: @escaping (P0) throws -> Void) async throws where P0: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0>(_ event: String, _ callback: @escaping (Environment, P0) throws -> Void) async throws where P0: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once<P0>(_ event: String, _ callback: @escaping (P0) async throws -> Void) async throws where P0: ValueConvertible {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    @available(*, noasync)
    func emit<P0>(_ env: Environment? = nil, _ event: String, _ p0: P0) throws where P0: ValueConvertible {
        try callSelf(env, "emit", event, p0)
    }

    func emit<P0>(_ event: String, _ p0: P0) async throws where P0: ValueConvertible {
        try await withEnvironment { env in try self.emit(env, event, p0) }
    }
}

// 0 param methods
public extension EventEmitter {
    @available(*, noasync)
    func on(_ env: Environment? = nil, _ event: String, _ callback: @escaping () throws -> Void) throws {
        try callSelf(env, "on", event, TypedFunction0(named: "on", callback))
    }

    @available(*, noasync)
    func on(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment) throws -> Void) throws {
        try callSelf(env, "on", event, TypedFunction0(named: "on", callback))
    }

    @available(*, noasync)
    func on(_ env: Environment? = nil, _ event: String, _ callback: @escaping () async throws -> Void) throws {
        try callSelf(env, "on", event, TypedFunction0(named: "on", callback))
    }

    func on(_ event: String, _ callback: @escaping () throws -> Void) async throws {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on(_ event: String, _ callback: @escaping (Environment) throws -> Void) async throws {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    func on(_ event: String, _ callback: @escaping () async throws -> Void) async throws {
        try await withEnvironment { env in try self.on(env, event, callback) }
    }

    @available(*, noasync)
    func once(_ env: Environment? = nil, _ event: String, _ callback: @escaping () throws -> Void) throws {
        try callSelf(env, "once", event, TypedFunction0(named: "once", callback))
    }

    @available(*, noasync)
    func once(_ env: Environment? = nil, _ event: String, _ callback: @escaping (Environment) throws -> Void) throws {
        try callSelf(env, "once", event, TypedFunction0(named: "once", callback))
    }

    @available(*, noasync)
    func once(_ env: Environment? = nil, _ event: String, _ callback: @escaping () async throws -> Void) throws {
        try callSelf(env, "once", event, TypedFunction0(named: "once", callback))
    }

    func once(_ event: String, _ callback: @escaping () throws -> Void) async throws {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once(_ event: String, _ callback: @escaping (Environment) throws -> Void) async throws {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    func once(_ event: String, _ callback: @escaping () async throws -> Void) async throws {
        try await withEnvironment { env in try self.once(env, event, callback) }
    }

    @available(*, noasync)
    func emit(_ env: Environment? = nil, _ event: String) throws {
        try callSelf(env, "emit", event)
    }

    func emit(_ event: String) async throws {
        try await withEnvironment { env in try self.emit(env, event) }
    }
}
