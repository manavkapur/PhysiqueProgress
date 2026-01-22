//
//  AccountDeletionService.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 23/01/26.
//

import FirebaseAuth
import FirebaseFirestore

final class AccountDeletionService {

    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {

        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "NoUser", code: 0)))
            return
        }

        let uid = user.uid

        // 1️⃣ Delete Firestore data
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .delete { firestoreError in

                if let firestoreError = firestoreError {
                    completion(.failure(firestoreError))
                    return
                }

                // 2️⃣ Delete Firebase Auth account
                user.delete { error in

                    if let error = error as NSError? {

                        // 🔐 Apple test case — requires recent login
                        if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                            completion(.failure(error))
                            return
                        }

                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
    }
}
