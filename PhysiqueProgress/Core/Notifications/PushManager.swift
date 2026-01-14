//
//  PushManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import UIKit
import FirebaseMessaging
import FirebaseAuth
import FirebaseFirestore

final class PushManager: NSObject {
    
    static let shared = PushManager()
    
    func registerForPush(application: UIApplication){
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
}


extension PushManager: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("✅ FCM token:", token)

        saveTokenToFirestore(token)
    }

    private func saveTokenToFirestore(_ token: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData([
                "fcmToken": token,
                "platform": "iOS",
                "updatedAt": Timestamp(date: Date())
            ], merge: true)
    }
    
    func clearTokenOnLogout() {
        guard
            let uid = Auth.auth().currentUser?.uid,
            let token = Messaging.messaging().fcmToken
        else { return }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData([
                "fcmToken": FieldValue.delete(),
                "tokenRemovedAt": Timestamp()
            ]) { error in
                if let error = error {
                    print("❌ Token cleanup failed:", error)
                } else {
                    print("✅ FCM token removed on logout")
                }
            }
    }


    
}
