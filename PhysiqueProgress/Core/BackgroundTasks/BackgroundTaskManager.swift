//
//  BackgroundTaskManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import BackgroundTasks

final class BackgroundTaskManager {
    
    static func register () {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: TaskIdentifiers.refresh, using: nil){task in
            handleRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    
    static func schedule(){
        let request = BGAppRefreshTaskRequest(identifier: TaskIdentifiers.refresh)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 6 * 60 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }
    
    private static func handleRefresh(task: BGAppRefreshTask){
        schedule()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let operation = BlockOperation {
            
            Task{
                _ = await SubscriptionManager.shared.hasPremiumAccess()
            }
        }
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        operation.completionBlock = {
            task.setTaskCompleted(success: true)
        }
        
        queue.addOperation {
            operation
        }
    }
}
