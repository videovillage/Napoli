import Foundation
import NAPIC

// The Swift owner can disappear on any executor. Node's cleanup-hook queue,
// however, must only be changed on the JavaScript thread. Retain this separate
// state through the TSFN finalizer rather than pointing a hook at the owner.
final class ThreadsafeFunctionLifetime {
    private let lock = NSLock()
    private var function: napi_threadsafe_function?
    private var ownerReleased = false
    private var cleanupHandle: napi_async_cleanup_hook_handle?

    func initialize(_ env: Environment, function callback: napi_value) throws {
        let resourceName = try "ThreadsafeWrapper".napiValue(env)
        let retained = Unmanaged.passRetained(self)
        let status = napi_create_threadsafe_function(env.env, callback, nil,
                                                     resourceName, 0, 1,
                                                     retained.toOpaque(),
                                                     typedFuncNAPIThreadsafeFinalize,
                                                     nil, typedFuncNAPIThreadsafeCallback,
                                                     &function)
        guard status == napi_ok else {
            retained.release()
            throw NAPIError(status)
        }
        do {
            try napi_add_async_cleanup_hook(env.env, threadsafeTypedFunctionCleanup,
                                            retained.toOpaque(), &cleanupHandle).throwIfError()
        } catch {
            releaseOwner()
            throw error
        }
    }

    func enqueue(_ data: UnsafeMutableRawPointer) -> napi_status {
        lock.lock()
        defer { lock.unlock() }
        guard !ownerReleased, let function else { return napi_closing }
        let acquired = napi_acquire_threadsafe_function(function)
        guard acquired == napi_ok else { return acquired }
        let status = napi_call_threadsafe_function(function, data, napi_tsfn_blocking)
        // A closing response already releases the acquired user in Node. No
        // raw TSFN pointer may survive across the Swift suspension point.
        if status != napi_closing {
            napi_release_threadsafe_function(function, napi_tsfn_release)
        }
        return status
    }

    func releaseOwner() {
        lock.lock()
        defer { lock.unlock() }
        guard !ownerReleased else { return }
        ownerReleased = true
        if let function {
            napi_release_threadsafe_function(function, napi_tsfn_release)
        }
    }

    // Node invokes the TSFN finalizer on its main thread. Clear the pointer
    // before Node tears down the queue. This is the only hook-removal site.
    func finalize() {
        lock.lock()
        function = nil
        ownerReleased = true
        lock.unlock()
        if let cleanupHandle {
            napi_remove_async_cleanup_hook(cleanupHandle)
            self.cleanupHandle = nil
        }
    }
}

func typedFuncNAPIThreadsafeFinalize(_: napi_env!, pointer: UnsafeMutableRawPointer?, hint _: UnsafeMutableRawPointer?) {
    guard let pointer else { return }
    Unmanaged<ThreadsafeFunctionLifetime>.fromOpaque(pointer).takeRetainedValue().finalize()
}

func threadsafeTypedFunctionCleanup(_: napi_async_cleanup_hook_handle!, _ arg: UnsafeMutableRawPointer!) {
    Unmanaged<ThreadsafeFunctionLifetime>.fromOpaque(arg).takeUnretainedValue().releaseOwner()
}
