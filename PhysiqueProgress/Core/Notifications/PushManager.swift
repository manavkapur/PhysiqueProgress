//
//  PushManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import UIKit
import FirebaseMessaging

final class PushManager: NSObject {
    
    static let shared = PushManager()
    
    func registerForPush(application: UIApplication){
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
}


extension PushManager: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM token:",  fcmToken ?? "")
    }
}
