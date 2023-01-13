//
//  BasicDemo.swift
//  
//
//  Created by Chiaote Ni on 2022/12/23.
//

import Foundation

public class BasicDemo {

    // MARK: before and after an async getter

    var value: String {
        get async {
            /*
             Just the same as the general cases that we use await for invoking an async function.
             When using get async, the system probably will change the executing thread.
             It depends on how long will the following job takes.

             For example, most of the time, the following code will print different threads at before and after await the sleep.
             However, the system probably won't change the executing thread if we only wait for 1 nanoseconds
             */
            Logger.logCurrentThread(withPrefix: "🛣 Thread GET0") // 3
            try? await Task.sleep(nanoseconds: 1000_000_000)
//            try? await Task.sleep(nanoseconds: 1)
            Logger.logCurrentThread(withPrefix: "🛣 Thread GET1") // 6
            return "what~"
        }
    }

    public func beforeAndAfterAsyncGetter() async {
        Logger.logCurrentThread(withPrefix: "🛣 1") // 3
        async let text1 = value
        Logger.logCurrentThread(withPrefix: "🛣 2") // 3
        async let text2 = value
        Logger.logCurrentThread(withPrefix: "🛣 3") // 6
        await print("texts", text1, text2)
        Logger.logCurrentThread(withPrefix: "🛣 4") // 6
    }

    public func run() async {
        /*
         The system will wait for the line 46 finish, then executing the line 47,
         and it have a chance to change the executing thread after the first await
         because of the 1 second delay (not 100%)
         */
        Logger.logCurrentThread(withPrefix: "🛣 Thread 0") // 3
        await Logger().print("yaya", delay: 1)
        Logger.logCurrentThread(withPrefix: "🛣 Thread 0-1") // 6
        await Logger().print("yoyo", delay: 0)
        Logger.logCurrentThread(withPrefix: "🛣 Thread 0-2") // 6

        await Logger().printInTask("yaya", delay: 1)
        await Logger().printInTask("yoyo", delay: 0)

        Logger.logCurrentThread(withPrefix: "🛣 Thread 2") // 4

        async let a: Void = Logger().printInTask("yaya", delay: 1)
        async let b: Void = Logger().printInTask("yoyo", delay: 0)
        await(a, b)

        Logger.logCurrentThread(withPrefix: "🛣 Thread 3") // 4

        async let text1 = value
        Logger.logCurrentThread(withPrefix: "🛣 Thread 4") // 4
        print("text2")
        async let text2 = value
        Logger.logCurrentThread(withPrefix: "🛣 Thread 5") // 3
        await print("text1", text1, text2)
        Logger.logCurrentThread(withPrefix: "🛣 Thread 6") // 3

        Task {
            Logger.logCurrentThread(withPrefix: "🛣 Thread 7") // 3
            await Logger().print("yaya", delay: 0)
            Logger.logCurrentThread(withPrefix: "🛣 Thread 7-2") // 3
        }

        let task = Task.detached {
            Logger.logCurrentThread(withPrefix: "🛣 Thread 8") // 5 // sometimes change, sometimes not
            await Logger().print("detached yaya", delay: 0)
            Logger.logCurrentThread(withPrefix: "🛣 Thread 8-2") // 5
        }

        Task {
            Logger.logCurrentThread(withPrefix: "🛣 Thread 9") // 3
            await Logger().print("yoyo", delay: 0)
            Logger.logCurrentThread(withPrefix: "🛣 Thread 9-2") // 3
        }

        Task { @MainActor in
            Logger.logCurrentThread(withPrefix: "🛣 Thread main") // 3
            await Logger().print("yoyo", delay: 0)
            Logger.logCurrentThread(withPrefix: "🛣 Thread main-2") // 3
        }
        //        await MainActor.run {
        //            Logger.logCurrentThread(with: "🛣 Thread main") // 3
        //            await Logger().print("yoyo", delay: 0)
        //            Logger.logCurrentThread(with: "🛣 Thread main-2") // 3
        //        }
        Logger.logCurrentThread(withPrefix: "🛣 Thread 10") // 3
    }
}
