import Foundation

open class EventEmitter: ObjectReference {
    @available(*, noasync)
    func on<F: TypedResultFunction>(_ env: Environment? = nil, _ event: String, _ function: F) throws where F.Result == Undefined {
        try callSelf(env, "on", event, function)
    }

    func on<F: TypedResultFunction>(_ event: String, _ function: F) async throws where F.Result == Undefined {
        try await callSelf("on", event, function)
    }
}
