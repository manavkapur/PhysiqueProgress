//
//  UserProfileService.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 14/01/26.
//

import FirebaseAuth
import FirebaseFirestore

final class UserProfileService {

    static let shared = UserProfileService()
    private init() {}

    private let db = Firestore.firestore()

    func createIfNeeded(user: User) {

        let ref = db.collection("users").document(user.uid)

        ref.getDocument { snapshot, error in
            if let snapshot, snapshot.exists {
                // ✅ Profile already exists
                return
            }

            // 🔥 Build profile
            let profile: [String: Any] = [
                "uid": user.uid,
                "email": user.email ?? "",
                "name": user.displayName ?? "",
                "photoURL": user.photoURL?.absoluteString ?? "",
                "provider": user.providerData.first?.providerID ?? "password",
                "createdAt": Timestamp(),
                "lastLoginAt": Timestamp(),
                "isPremium": false
            ]

            ref.setData(profile) { error in
                if let error {
                    print("❌ Failed to create profile:", error.localizedDescription)
                } else {
                    print("✅ Firestore profile created")
                }
            }
        }
    }

    func updateLastLogin(user: User) {
        db.collection("users")
            .document(user.uid)
            .updateData([
                "lastLoginAt": Timestamp()
            ])
    }
}
