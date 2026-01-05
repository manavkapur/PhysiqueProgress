//
//  BiometricAuthManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import LocalAuthentication

final class BiometricAuthManager {

    static func authenticate(
        reason: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            completion(false)
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        ) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
}
