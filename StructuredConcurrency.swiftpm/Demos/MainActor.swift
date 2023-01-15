//
//  File.swift
//  
//
//  Created by Chiaote Ni on 2022/12/30.
//

import Foundation

class MainActorDemo {

    // MARK: About executing order

    @MainActor
    func run() async {
        Task.detached(operation: {
            Logger.logCurrentThread(withPrefix: "🐪1")

            await MainActor.run(body: {
                Logger.logCurrentThread(withPrefix: "🐪2")

                Task { @MainActor in
                    Logger.logCurrentThread(withPrefix: "🐪3")
                }
                Logger.logCurrentThread(withPrefix: "🐪4")
            })

            Logger.logCurrentThread(withPrefix: "🐪5")
        }) 
    }

    // MARK: About Common Usage

    public func executeLongTimeJob() async {
        Logger.logCurrentThread(withPrefix: "🎁1")
        await withCheckedContinuation({ continuation in
            Logger.logCurrentThread(withPrefix: "🎁2")
            for i in 0 ..< 5 {
                print(i)
                usleep(10_000_000)
                //            try await Task.sleep(nanoseconds: 10_000_000_000)
            }
            continuation.resume()
        })
        Logger.logCurrentThread(withPrefix: "🎁3")
    }

    public func executeLongTimeJobWithMainActorAttributeInTask() async {
        Task { @MainActor in
            Logger.logCurrentThread(withPrefix: "🎁0")
            await executeLongTimeJob()
            Logger.logCurrentThread(withPrefix: "🎁4")
        }
    }

    @MainActor
    public func executeLongTimeJobWithMainActorFunction() async {
        Logger.logCurrentThread(withPrefix: "🎁0")
        await executeLongTimeJob()
        Logger.logCurrentThread(withPrefix: "🎁4")
    }
}
