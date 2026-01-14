//
//  AuthService.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 01/01/26.
//

import FirebaseAuth

final class AuthService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ){
        Auth.auth().signIn(withEmail: email, password: password){ _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    }
    
    func signup(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(.failure(error))
                return
            }

            // 🔥 THIS IS STEP 4 — SEND VERIFICATION MAIL
            Auth.auth().currentUser?.sendEmailVerification { error in
                if let error {
                    print("❌ Verification email error:", error.localizedDescription)
                    completion(.failure(error))
                } else {
                    print("✅ Verification email sent")
                    completion(.success(()))
                }
            }

        }
    }

    func isEmailVerified() -> Bool {
        Auth.auth().currentUser?.isEmailVerified ?? false
    }

    func reloadUser(completion: @escaping (Bool) -> Void) {
        Auth.auth().currentUser?.reload { _ in
            completion(self.isEmailVerified())
        }
    }

    func resendVerification(completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification(completion: completion)
    }

}
