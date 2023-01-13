//
//  File.swift
//  
//
//  Created by Chiaote Ni on 2022/12/23.
//

import UIKit

public class CollageExporter {
    let collage: Collage

    private let queue = OperationQueue()

    init(collage: Collage) {
        self.collage = collage
    }

    public func exportWithOperation() {
        print("💻 exportWithOperation")
        let finalOperation = BlockOperation { [weak self] in
            self?.finalProcess()
        }
        var operations: [Operation] = collage.scraps.compactMap { scrap in
            ImageOperation { scrap.exportImage() }
        }

        operations.forEach { finalOperation.addDependency($0) }
        operations.append(finalOperation)

        queue.addOperations(operations, waitUntilFinished: true)
    }

    public func exportWithAsyncAwait() async throws {
        print("💻 exportWithAsyncAwait")
        var images: [UIImage] = []
        for scrap in collage.scraps {
            let image = try await scrap.export()
            images.append(image)
        }
        print(images.count)
        finalProcess()
    }

    public func exportWithTasks() async throws {
        print("💻 exportWithTasks")
        let tasks = collage.scraps
            .map { $0.exportWithTask() }

        var images: [UIImage] = []
        for task in tasks {
            let image = try await task.value
            images.append(image)
        }
        print(images.count)
        finalProcess()
    }

    public func exportWithTaskGroup() async throws {
        print("💻 exportWithTaskGroup")
        // TaskGroup: AsyncSequence
        let images = try await withThrowingTaskGroup(of: UIImage?.self, returning: [UIImage].self, body: { group in
            collage.scraps.forEach { scrap in
                group.addTask { try await scrap.export() }
            }

            // Some other way:
            // https://github.com/JohnSundell/CollectionConcurrencyKit/blob/main/Sources/CollectionConcurrencyKit.swift
            return try await group.reduce(into: [UIImage](), { partialResult, element in
                guard let image = element else { return }
                partialResult.append(image)
            })
        })

        print(images.count)
        finalProcess()
    }

    func finalProcess() {
        print("🎁", "Finish~~~~")
    }
}
