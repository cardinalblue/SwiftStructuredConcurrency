import UIKit
import AVFoundation

public protocol Scrap {
    var delay: Float { get }
    var imageName: String? { get }
    init()
    func exportImage() -> UIImage?
    func export() async throws -> UIImage
    func exportWithTask() -> Task<UIImage, Error>
}

extension Scrap {

    private func makeImage() -> UIImage {
        if let imageName = imageName {
            return UIImage(named: imageName)!
        } else {
            return UIImage()
        }
    }
    public func exportImage() -> UIImage? {
        print("💻 Exporting \(Self.self)")
        usleep(UInt32(delay / 1000))
        return makeImage()
    }

    public func export() async throws -> UIImage {
        print("💻 Exporting \(Self.self)")
        try await Task.sleep(nanoseconds: UInt64(delay))
        return makeImage()
    }

    public func exportWithTask() -> Task<UIImage, Error> {
        Task {
            try await export()
        }
    }
}


public class ImageScrap: Scrap {
    public var delay: Float = 1 * 1000_000_000
    public var imageName: String?
    required public init() {}
}

public class VideoScrap: Scrap {
    public let delay: Float = 2 * 1000_000_000
    public var imageName: String?
    required public init() {}
}

public class StickerScrap: Scrap {
    public var delay: Float = 1.5 * 1000_000_000
    public var imageName: String?
    required public init() {}
}

public class TextScrap: Scrap {
    public let delay: Float = 0.5 * 1000_000_000
    public var imageName: String?
    required public init() {}
}
