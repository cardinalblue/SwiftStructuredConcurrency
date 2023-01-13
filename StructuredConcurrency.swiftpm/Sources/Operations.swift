import UIKit

public class ImageOperation: AsynchronousOperation {

    private(set) var result: UIImage?

    private var action: () -> UIImage?

    public init(_ action: @escaping () -> UIImage?) {
        self.action = action
    }

    public override func main() {
        super.main()
        DispatchQueue.global().async {
            self.result = self.action()
            DispatchQueue.main.async {
                self.state = .finished
            }
        }
    }
}

public class AsynchronousOperation: Operation {

    enum State: String {
        case ready, executing, finished

        var keyPath: String {
            "is\(rawValue.capitalized)"
        }
    }

    public override var isAsynchronous: Bool { true }
    public override var isExecuting: Bool { state == .executing }
    public override var isFinished: Bool { state == .finished }

    var state: State = .ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    private let queue = DispatchQueue(
        label: "com.queue.asynchronousOperation",
        qos: .userInteractive,
        autoreleaseFrequency: .workItem,
        target: .global()
    )

    public override func start() {
        super.start()
        if isCancelled {
            state = .finished
            return
        }
        state = .executing
    }

    public override func cancel() {
        state = .finished
    }
}
