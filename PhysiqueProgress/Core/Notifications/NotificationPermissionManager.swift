//
//  NotificationPermissionManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import UserNotifications

final class NotificationPermissionManager {
    
    static func requestPermission(
        completion: @escaping (Bool) -> Void
    ) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ){granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
            print("Notification permission: \(granted)")
        }
        
    }
}
