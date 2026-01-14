//
//  SignupViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 01/01/26.
//

import Foundation
import Combine

final class SignupViewModel {

    private let authService = AuthService()

    var onSignupSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    func signup(email: String, password: String, confirmPassword: String) {

        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            onError?("All fields are required")
            return
        }

        guard password.count >= 6 else {
            onError?("Password must be at least 6 characters")
            return
        }

        guard password == confirmPassword else {
            onError?("Passwords do not match")
            return
        }

        onLoading?(true)

        authService.signup(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)

                switch result {
                case .success:
                    self?.onSignupSuccess?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
