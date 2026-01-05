//
//  FirebaseSubscriptionService.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.



import FirebaseFirestore

final class FirebaseSubscriptionService {

    private let db = Firestore.firestore()

    func updatePremiumStatus(
        userId: String,
        isPremium: Bool
    ) {
        db.collection("users")
            .document(userId)
            .setData([
                "isPremium": isPremium,
                "updatedAt": Timestamp()
            ], merge: true)
    }
}
