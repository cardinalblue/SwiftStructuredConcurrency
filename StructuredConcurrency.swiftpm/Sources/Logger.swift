import Foundation

enum Logger {

    static func print(_ string: String, delay: Float = 0) async {
        try? await Task.sleep(nanoseconds: UInt64(delay * 1000_000_000))
        Swift.print(string)
    }

    static func printInTask(_ string: String, delay: Float = 0) {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1000_000_000))
            Swift.print(string)
        }
    }

    static func asyncPrint(_ string: String, delay: Float = 0) async {
        let task = Task {
            Swift.print("start", string)
            try? await Task.sleep(nanoseconds: UInt64(delay * 1000_000_000))
            Swift.print("end", string)
        }
        await task.value
    }

    static func logCurrentThread(withPrefix string: String = "") {
        // Class property 'current' is unavailable from asynchronous contexts;
        // Thread.current cannot be used from async contexts.; this is an error in Swift 6
        Swift.print(string, Thread.current)
    }
}
