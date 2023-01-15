//
//  BasicDemo.swift
//  
//
//  Created by Chiaote Ni on 2022/12/23.
//

import Foundation

public class BasicDemo {

    public func run() async {
        /*
         The system will wait for the line 46 finish, then executing the line 47,
         and it have a chance to change the executing thread after the first await
         because of the 1 second delay (not 100%)
         */
        Logger.logCurrentThread(withPrefix: "🛣 Thread 0") // 3
        await Logger().print("yaya", delay: 3)
        Logger.logCurrentThread(withPrefix: "🛣 Thread 0-1") // 6
        await Logger().print("yoyo", delay: 0)
        Logger.logCurrentThread(withPrefix: "🛣 Thread 0-2") // 6 or another

        /*
         In the line 73 & 74, it will print "yoyo" then print "yaya" event though we execute printing "yaya" first.
         This is because we executing print in tasks, so that the system won't wait for finishing printing "yaya".
         */
        Logger().printInTask("yaya", delay: 3)
        Logger().printInTask("yoyo", delay: 0)

        /*
         In the following code, from 1-1 to 1-3, the asyncPrint won't execute at lines 81 & 82 but will wait until line 84 when we invoke them with await.
         Also, it will only execute one for each asyncPrint, then keep the result until it release, so it will only executing once event though we await yaya twice
         */
        Logger.logCurrentThread(withPrefix: "🛣 Thread 1-1") // 6
        async let yaya: Void = Logger().asyncPrint("yaya", delay: 3)
        async let yoyo: Void = Logger().asyncPrint("yoyo", delay: 0)
        Logger.logCurrentThread(withPrefix: "🛣 Thread 1-2") // 6
        await(yaya, yoyo, yaya)
        Logger.logCurrentThread(withPrefix: "🛣 Thread 1-3") // 8
    }

    public func aboutTaskAndDetachedTask() {
        /*
         The Task will inherit the current context automatically unless it's executing on the main thread.
         You can do with Task.detached to ask the system not to inherit the current executing context so that it will force change the executing thread as well.

         The log would be kind like this:
         🛣 current 0: Thread number 3
         🛣 current 1: Thread number 3
         🛣 current 2: Thread number 3

         🛣 task 0: Thread number 3
         🛣 detached task 0: Thread number 7
         task
         🛣 task 1: Thread number 3
         detached task
         🛣 detached task 1: Thread number 7
         */

        Task {
            Logger.logCurrentThread(withPrefix: "🛣 current 0")

            Task {
                Logger.logCurrentThread(withPrefix: "🛣 task 0")
                await Logger().print("task", delay: 0)
                Logger.logCurrentThread(withPrefix: "🛣 task 1")
            }
            Logger.logCurrentThread(withPrefix: "🛣 current 1")

            Task.detached {
                Logger.logCurrentThread(withPrefix: "🛣 detached task 0")
                await Logger().print("detached task", delay: 0)
                Logger.logCurrentThread(withPrefix: "🛣 detached task 1")
            }
            Logger.logCurrentThread(withPrefix: "🛣 current 2")
        }
    }

    public func waitForNoReturnValueTask() async {
        let task = Task {
            Logger.logCurrentThread(withPrefix: "🛣 YA")
        }
        let task2 = Task {
            Logger.logCurrentThread(withPrefix: "🛣 YO")
        }
        await task.value    // It's ok if the task only result Void
        await task.result   // The Xcode will expect that we will use the result, so we can see a warning if we just do like this.
        // Also, the result type will be defined automatically with the closure we declared.
        // That means it will change to Task<(), Error> if we have thrown an error during the closure.
    }

    // MARK: Before and after an async getter

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
}
