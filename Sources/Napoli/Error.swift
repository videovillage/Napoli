import NAPIC

public enum Error: Swift.Error {
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
        default: self = .unknown(UInt32(napiStatus.rawValue))
        }
    }
}

public struct JSException: Swift.Error {
    let value: napi_value
}

extension Error {
    func napi_throw(_ env: napi_env) -> napi_status {
        switch self {
        case .objectExpected: return napi_throw_type_error(env, nil, "Expected object")
        case .stringExpected: return napi_throw_type_error(env, nil, "Expected string")
        case .nameExpected: return napi_throw_type_error(env, nil, "Expected Symbol or string")
        case .functionExpected: return napi_throw_type_error(env, nil, "Expected function")
        case .numberExpected: return napi_throw_type_error(env, nil, "Expected number")
        case .booleanExpected: return napi_throw_type_error(env, nil, "Expected boolean")
        case .arrayExpected: return napi_throw_type_error(env, nil, "Expected array")
        case .bigintExpected: return napi_throw_type_error(env, nil, "Expected BigInt")
        case .dateExpected: return napi_throw_type_error(env, nil, "Expected Date")
        case .arrayBufferExpected: return napi_throw_type_error(env, nil, "Expected Array Buffer")
        case .detachableArrayBufferExpected: return napi_throw_type_error(env, nil, "Expected Detachable Array Buffer")
        default: return napi_throw_error(env, nil, localizedDescription)
        }
    }
}

extension napi_status {
    func throwIfError() throws {
        guard self == napi_ok else {
            throw Napoli.Error(self)
        }
    }
}
