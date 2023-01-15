//
//  OperationRelatedDemo.swift
//  
//
//  Created by Chiaote Ni on 2022/12/23.
//

import Foundation

public struct WaitForParallelTasksDemo {

    public func run() async {
        let collage = Collage(scraps: [
            ImageScrap(),
            VideoScrap(),
            TextScrap(),
            StickerScrap()
        ])
        let exporter = CollageExporter(collage: collage)

        Task {
//            exporter.exportWithOperation()
            Logger.logCurrentThread(withPrefix: "")
            do {
//                try await exporter.exportWithAsyncAwait()
//                try await exporter.exportWithTasks()
                try await exporter.exportWithTaskGroup()

//                async let _
            } catch {
                print(error.localizedDescription.debugDescription)
            }
        }
    }
}
