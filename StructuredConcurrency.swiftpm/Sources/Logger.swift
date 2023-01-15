import Foundation

struct Logger {

    func print(_ string: String, delay: Float = 0) async {
        try? await Task.sleep(nanoseconds: UInt64(delay * 1000_000_000))
        Swift.print(string)
    }

    func printInTask(_ string: String, delay: Float = 0) {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1000_000_000))
            Swift.print(string)
        }
    }

    func asyncPrint(_ string: String, delay: Float = 0) async {
        let task = Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1000_000_000))
            Swift.print(string)
        }
        await task.value
    }

    static func logCurrentThread(withPrefix string: String = "") {
        // Class property 'current' is unavailable from asynchronous contexts;
        // Thread.current cannot be used from async contexts.; this is an error in Swift 6
        Swift.print(string, Thread.current)
    }
}
