import NAPIC

public enum NAPIError: Swift.Error {
    case invalidArg
    case objectExpected
    case stringExpected
    case nameExpected
    case functionExpected
    case numberExpected
    case booleanExpected
    case arrayExpected
    case genericFailure
    case pendingException
    case cancelled
    case escapeCalledTwice
    case handleScopeMismatch
    case callbackScopeMismatch
    case queueFull
    case closing
    case bigintExpected
    case dateExpected
    case arrayBufferExpected
    case detachableArrayBufferExpected
    case wouldDeadlock
    case noExternalBuffersAllowed
    case unknown(UInt32)

    public init(_ napiStatus: napi_status) {
        switch napiStatus.rawValue {
        case napi_invalid_arg.rawValue: self = .invalidArg
        case napi_object_expected.rawValue: self = .objectExpected
        case napi_string_expected.rawValue: self = .stringExpected
        case napi_name_expected.rawValue: self = .nameExpected
        case napi_function_expected.rawValue: self = .functionExpected
        case napi_number_expected.rawValue: self = .numberExpected
        case napi_boolean_expected.rawValue: self = .booleanExpected
        case napi_array_expected.rawValue: self = .arrayExpected
        case napi_generic_failure.rawValue: self = .genericFailure
        case napi_pending_exception.rawValue: self = .pendingException
        case napi_cancelled.rawValue: self = .cancelled
        case napi_escape_called_twice.rawValue: self = .escapeCalledTwice
        case napi_handle_scope_mismatch.rawValue: self = .handleScopeMismatch
        case napi_callback_scope_mismatch.rawValue: self = .callbackScopeMismatch
        case napi_queue_full.rawValue: self = .queueFull
        case napi_closing.rawValue: self = .closing
        case napi_bigint_expected.rawValue: self = .bigintExpected
        case napi_date_expected.rawValue: self = .dateExpected
        case napi_arraybuffer_expected.rawValue: self = .arrayBufferExpected
        case napi_detachable_arraybuffer_expected.rawValue: self = .detachableArrayBufferExpected
        case napi_would_deadlock.rawValue: self = .wouldDeadlock
        case napi_no_external_buffers_allowed.rawValue: self = .noExternalBuffersAllowed
        default: self = .unknown(UInt32(napiStatus.rawValue))
        }
    }
}

extension napi_status {
    func throwIfError() throws {
        guard self == napi_ok else {
            throw NAPIError(self)
        }
    }
}
