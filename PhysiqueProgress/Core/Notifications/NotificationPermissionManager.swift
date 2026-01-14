//
//  NotificationPermissionManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import UserNotifications
import FirebaseAnalytics
import UIKit
import FirebaseAuth


final class NotificationPermissionManager {

    static func requestPermission(completion: @escaping (Bool) -> Void) {

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, _ in

            DispatchQueue.main.async {
                if granted {
                    PushManager.shared.registerForPush(application: UIApplication.shared)
                }
                completion(granted)
            }

            print("Notification permission: \(granted)")
            
            Analytics.logEvent("notification_permission", parameters: [
                "granted": granted
            ])

        }
    }
}
