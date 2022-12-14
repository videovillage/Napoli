import Foundation

open class EventEmitter: ObjectReference {
    @available(*, noasync)
    public func removeAllListeners(_ env: Environment? = nil, _ event: String? = nil) throws {
        if let event {
            try callSelf(env, "removeAllListeners", event)
        } else {
            try callSelf(env, "removeAllListeners")
        }
    }

    public func removeAllListeners(_ event: String? = nil) async throws {
        if let event {
            try await callSelf("removeAllListeners", event)
        } else {
            try await callSelf("removeAllListeners")
        }
    }
}
