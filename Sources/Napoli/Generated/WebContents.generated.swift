// swiftformat:disable opaqueGenericParameters

import Foundation
import NAPIC

public class WebContents: EventEmitter {}

// 8 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0, P1, P2, P3, P4, P5, P6, P7>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3, p4, p5, p6, p7)
    }

    func send<P0, P1, P2, P3, P4, P5, P6, P7>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible, P7: ValueConvertible {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3, p4, p5, p6, p7) }
    }
}

// 7 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0, P1, P2, P3, P4, P5, P6>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3, p4, p5, p6)
    }

    func send<P0, P1, P2, P3, P4, P5, P6>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible, P6: ValueConvertible {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3, p4, p5, p6) }
    }
}

// 6 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0, P1, P2, P3, P4, P5>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3, p4, p5)
    }

    func send<P0, P1, P2, P3, P4, P5>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible, P5: ValueConvertible {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3, p4, p5) }
    }
}

// 5 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0, P1, P2, P3, P4>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3, p4)
    }

    func send<P0, P1, P2, P3, P4>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible, P4: ValueConvertible {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3, p4) }
    }
}

// 4 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0, P1, P2, P3>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try callSelf(env: env, "send", channel, p0, p1, p2, p3)
    }

    func send<P0, P1, P2, P3>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible, P3: ValueConvertible {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2, p3) }
    }
}

// 3 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0, P1, P2>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1, _ p2: P2) throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try callSelf(env: env, "send", channel, p0, p1, p2)
    }

    func send<P0, P1, P2>(_ channel: String, _ p0: P0, _ p1: P1, _ p2: P2) async throws where P0: ValueConvertible, P1: ValueConvertible, P2: ValueConvertible {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1, p2) }
    }
}

// 2 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0, P1>(env: Environment? = nil, _ channel: String, _ p0: P0, _ p1: P1) throws where P0: ValueConvertible, P1: ValueConvertible {
        try callSelf(env: env, "send", channel, p0, p1)
    }

    func send<P0, P1>(_ channel: String, _ p0: P0, _ p1: P1) async throws where P0: ValueConvertible, P1: ValueConvertible {
        try await withEnvironment { env in try self.send(env: env, channel, p0, p1) }
    }
}

// 1 param methods
public extension WebContents {
    @available(*, noasync)
    func send<P0>(env: Environment? = nil, _ channel: String, _ p0: P0) throws where P0: ValueConvertible {
        try callSelf(env: env, "send", channel, p0)
    }

    func send<P0>(_ channel: String, _ p0: P0) async throws where P0: ValueConvertible {
        try await withEnvironment { env in try self.send(env: env, channel, p0) }
    }
}

// 0 param methods
public extension WebContents {
    @available(*, noasync)
    func send(env: Environment? = nil, _ channel: String) throws {
        try callSelf(env: env, "send", channel)
    }

    func send(_ channel: String) async throws {
        try await withEnvironment { env in try self.send(env: env, channel) }
    }
}
