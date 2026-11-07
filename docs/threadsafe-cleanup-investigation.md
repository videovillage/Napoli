# Thread-safe function cleanup and Electron 8W

[Electron 8W](https://video-village.sentry.io/issues/VIDEO-VILLAGE-PLUGINS-ELECTRON-8W)
crashed on Windows in Node's environment cleanup-hook hash-table insertion,
through Napoli's `EnvironmentAccessor` and thread-safe function creation.
The event used Electron 36.9.5 / Node 22.19.0 and manager 2.3.23.

Napoli registers each cleanup hook on the JavaScript thread but previously
removed it directly in the Swift wrapper's destructor, which can run on a Swift
executor. Node's [cleanup queue implementation](https://github.com/nodejs/node/blob/v22.19.0/src/cleanup_queue-inl.h)
mutates the same unordered set for insertion and removal without a lock. This
is a concrete race candidate matching the affected data structure, independent
of any license-server worker loss.

An isolated test creates callbacks on the JS thread, invokes them from eight
Swift tasks, and releases them on Swift executors. A temporary assertion at the
old hook-removal site trapped on a background thread in
`ThreadsafeTypedFunction.deinit`. The uninstrumented stress run completed on
macOS; it did not reproduce the Windows hash-table access violation. The
assertion was removed after establishing which thread performs removal.

The patch retains a separate lifetime object until the Node thread-safe
function's finalizer. Swift destruction only releases the owner's thread-safe
reference. Hook removal runs in that finalizer, which Node
[documents as a main-thread callback](https://nodejs.org/download/release/v22.19.0/docs/api/n-api.html#asynchronous-thread-safe-function-calls).
The environment hook and Swift destruction share an idempotent, locked release;
callers acquire under that lock before shutdown can release the owner. Rejected
enqueues and drained callbacks resume their Swift continuations with an error.

The regression runs in a child process so a crash, timeout or failure to drain
callbacks fails explicitly. On macOS, Swift 6.4.2 / Node 22.23.4, all suites
except `classes.js` completed, including the 16,000-callback cleanup stress.
The complete suite aborts in `classes.js` casting `Optional<OpaquePointer>` to
`OpaquePointer`; the unchanged implementation aborts identically with this
compiler. The addon entry point is explicitly public to keep its C symbol
exported by the current compiler. Generated source must match the generator.

Before treating 8W as resolved, require the repository's Windows/Linux/macOS CI,
exercise the affected Electron build on Windows, then update the consuming
manager's pinned Napoli revision in a separately reviewed integration change.
This patch does not establish recovery for the reported user's crashed session
or resolve the separate Mirage initialization report.
