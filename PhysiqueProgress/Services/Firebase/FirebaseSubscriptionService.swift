//
//  FirebaseSubscriptionService.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.


//
//  FirebaseSubscriptionService.swift
//  PhysiqueProgress
//

import FirebaseFirestore
import FirebaseAnalytics

final class FirebaseSubscriptionService {

    private let db = Firestore.firestore()

    func updatePremiumStatus(userId: String, isPremium: Bool) {

        let data: [String: Any] = [
            "isPremium": isPremium,
            "updatedAt": Timestamp(date: Date())
        ]

        db.collection("users")
            .document(userId)
            .setData(data, merge: true)

        // 🔥 Analytics mirror
        Analytics.setUserProperty(isPremium ? "true" : "false", forName: "is_premium")

        if isPremium {
            Analytics.logEvent("premium_active", parameters: nil)
        } else {
            Analytics.logEvent("premium_inactive", parameters: nil)
        }
    }
}

