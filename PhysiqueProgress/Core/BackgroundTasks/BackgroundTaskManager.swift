//
//  BackgroundTaskManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import BackgroundTasks

final class BackgroundTaskManager {

    static func register() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: TaskIdentifiers.refresh,
            using: nil
        ) { task in
            handleRefresh(task: task as! BGAppRefreshTask)
        }
    }

    static func schedule() {

        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: TaskIdentifiers.refresh)

        let request = BGAppRefreshTaskRequest(identifier: TaskIdentifiers.refresh)
        // 🔥 TEMP TEST (15 seconds)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15)

        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ BG task scheduled")
        } catch {
            print("❌ BG task schedule failed:", error)
        }
    }

    private static func handleRefresh(task: BGAppRefreshTask) {
       
        print("🔥 BG TASK FIRED")
        schedule() // re-schedule next cycle

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        let operation = BlockOperation {
            let semaphore = DispatchSemaphore(value: 0)
            
            Task {
                _ = await SubscriptionManager.shared.hasPremiumAccess()
                semaphore.signal()
            }
            semaphore.wait()
        }
        operation.completionBlock = {
            task.setTaskCompleted(success: true)
        }

        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        queue.addOperation(operation)
    }
}
