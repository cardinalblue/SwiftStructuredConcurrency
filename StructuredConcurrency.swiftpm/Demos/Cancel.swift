//
//  File.swift
//  
//
//  Created by Chiaote Ni on 2022/12/30.
//

import Foundation

class CancelDemo {
    func run() async {

        let task = Task {
            print("😂", 1)
            async let a: Void = {
                print("😂", 2)
                throw CancellationError()
            }()

            print("😂", 3)
            async let b: Void = {
                print("🎁0", Task.isCancelled)
                try await Task.sleep(nanoseconds: 1_000)
                print("🎁1", Task.isCancelled)
            }()

            print("😂", 4)
            do {
                print("😂", 5)
                try await(a, b)
            } catch {
                print(error)
            }
            // if b throw error, a will be cancelled as well
        }
//        task.cancel()
    }
}
