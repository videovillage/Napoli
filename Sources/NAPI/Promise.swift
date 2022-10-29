import NAPIC
import Foundation

class PromiseData {
    var deferred: napi_deferred?
    let args: Arguments
    let function: AsyncCallback
    var result: Result<ValueConvertible?, Swift.Error>?

    init(args: Arguments, function: @escaping AsyncCallback) {
        self.deferred = .init(bitPattern: 0)
        self.args = args
        self.function = function
    }
}

extension Task {
    /// You better know what you're doing!
    @discardableResult
    func waitSync() -> Result<Success, Failure> {
        let semaphore = DispatchSemaphore(value: 0)

        var res: Result<Success, Failure>?
        let complete = { (result: Result<Success, Failure>) in
            res = result
            semaphore.signal()
        }

        Task<Void, Never>.detached {
            complete(await self.result)
        }

        semaphore.wait()

        return res!
    }
}
