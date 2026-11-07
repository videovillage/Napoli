// swiftformat:disable opaqueGenericParameters

import Foundation
import NAPIC

public class WebContents: EventEmitter {}

/// 8 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3, p4, p5, p6, p7) }
    }
}

/// 7 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3, p4, p5, p6)
    }

    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3, p4, p5, p6) }
    }
}

/// 6 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3, p4, p5)
    }

    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3, p4, p5) }
    }
}

/// 5 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3, p4)
    }

    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3, p4) }
    }
}

/// 4 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3)
    }

    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3) }
    }
}

/// 3 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2) throws {
        try callSelf(env: env, "send", channel, p0, p1, p2)
    }

    func send<P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2) }
    }
}

/// 2 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0: ValueConvertible, P1: ValueConvertible>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1) throws {
        try callSelf(env: env, "send", channel, p0, p1)
    }

    func send<P0: ValueConvertible, P1: ValueConvertible>(_ channel: String, _ p0: P0, _ p1: P1) async throws {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1) }
    }
}

/// 1 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0: ValueConvertible>(env: Environment? = nil, _ channel: String, _ p0: P0) throws {
        try callSelf(env: env, "send", channel, p0)
    }

    func send<P0: ValueConvertible>(_ channel: String, _ p0: P0) async throws {
        try await withEnvironment { env in try self.send(env: env, channel, p0) }
    }
}

/// 0 param methods
public extension WebContents {
    @available(*, noasync)
    func send(env: Environment? = nil, _ channel: String) throws {
        try callSelf(env: env, "send", channel)
    }

    func send(_ channel: String) async throws {
        try await withEnvironment { env in try self.send(env: env, channel) }
    }
}
