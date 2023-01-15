import SwiftUI
import UIKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            DemoRepresentView()
                .task {
                    Logger.logCurrentThread()

                    await BasicDemo().run()
//                    await BasicDemo().beforeAndAfterAsyncGetter()
//                    await BasicDemo().aboutTaskAndDetachedTask()
//                    await BasicDemo().waitForNoReturnValueTask()

//                    await MainActorDemo().run()
//                    await MainActorDemo().executeLongTimeJobWithMainActor()
//                    await MainActorDemo().executeLongTimeJob()

//                    await CancelDemo().run()
//                    await WaitForParallelTasksDemo().run()

                    Logger.logCurrentThread()
                }
        }
    }
}
