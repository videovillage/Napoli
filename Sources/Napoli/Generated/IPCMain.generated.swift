// swiftformat:disable opaqueGenericParameters

import Foundation
import NAPIC

public class IPCMain: EventEmitter {}

/// 8 param methods
public extension IPCMain {
    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction8(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction8(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction8(named: "handle", callback))
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction8(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction8(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction8(named: "handleOnce", callback))
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6, P7) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }
}

/// 7 param methods
public extension IPCMain {
    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction7(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction7(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) async throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction7(named: "handle", callback))
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction7(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction7(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) async throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction7(named: "handleOnce", callback))
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5, P6) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5, P6) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }
}

/// 6 param methods
public extension IPCMain {
    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction6(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction6(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) async throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction6(named: "handle", callback))
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction6(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction6(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) async throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction6(named: "handleOnce", callback))
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4, P5) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4, P5) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }
}

/// 5 param methods
public extension IPCMain {
    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction5(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction5(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4) async throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction5(named: "handle", callback))
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction5(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction5(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4) async throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction5(named: "handleOnce", callback))
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3, P4) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3, P4) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }
}

/// 4 param methods
public extension IPCMain {
    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction4(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction4(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3) async throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction4(named: "handle", callback))
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction4(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction4(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2, P3) async throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction4(named: "handleOnce", callback))
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2, P3) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2, P3) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }
}

/// 3 param methods
public extension IPCMain {
    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction3(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction3(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2) async throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction3(named: "handle", callback))
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction3(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1, P2) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction3(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1, P2) async throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction3(named: "handleOnce", callback))
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1, P2) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1, P2) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }
}

/// 2 param methods
public extension IPCMain {
    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction2(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction2(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1) async throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction2(named: "handle", callback))
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction2(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0, P1) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction2(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0, P1) async throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction2(named: "handleOnce", callback))
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0, P1) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible, P1: ValueConvertible>(_ channel: String, _ callback: @escaping (P0, P1) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }
}

/// 1 param methods
public extension IPCMain {
    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction1(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction1(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible, P0: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0) async throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction1(named: "handle", callback))
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible>(_ channel: String, _ callback: @escaping (P0) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible, P0: ValueConvertible>(_ channel: String, _ callback: @escaping (P0) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction1(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment, P0) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction1(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible, P0: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (P0) async throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction1(named: "handleOnce", callback))
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible>(_ channel: String, _ callback: @escaping (P0) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment, P0) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible, P0: ValueConvertible>(_ channel: String, _ callback: @escaping (P0) async throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }
}

/// 0 param methods
public extension IPCMain {
    @available(*, noasync)
    func handle<Result: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping () throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction0(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment) throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction0(named: "handle", callback))
    }

    @available(*, noasync)
    func handle<Result: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping () async throws -> Result) throws {
        try callSelf(env: env, "handle", channel, TypedFunction0(named: "handle", callback))
    }

    func handle<Result: ValueConvertible>(_ channel: String, _ callback: @escaping () throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment) throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    func handle<Result: ValueConvertible>(_ channel: String, _ callback: @escaping () async throws -> Result) async throws {
        try await withEnvironment { env in try self.handle(env: env, channel, callback) }
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping () throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction0(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping (Environment) throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction0(named: "handleOnce", callback))
    }

    @available(*, noasync)
    func handleOnce<Result: ValueConvertible>(env: Environment? = nil, _ channel: String, _ callback: @escaping () async throws -> Result) throws {
        try callSelf(env: env, "handleOnce", channel, TypedFunction0(named: "handleOnce", callback))
    }

    func handleOnce<Result: ValueConvertible>(_ channel: String, _ callback: @escaping () throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible>(_ channel: String, _ callback: @escaping (Environment) throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }

    func handleOnce<Result: ValueConvertible>(_ channel: String, _ callback: @escaping () async throws -> Result) async throws {
        try await withEnvironment { env in try self.handleOnce(env: env, channel, callback) }
    }
}
