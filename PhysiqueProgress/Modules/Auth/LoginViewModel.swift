//
//  LoginViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//
import Foundation
import FirebaseAuth

final class LoginViewModel {

    private let authService = AuthService()

    var onLoginSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            onError?("Email and password are required")
            return
        }

        onLoading?(true)

        authService.login(email: email, password: password) { [weak self] result in
            self?.onLoading?(false)

            switch result {
            case .success:
                if Auth.auth().currentUser?.isEmailVerified == true {
                    self?.onLoginSuccess?()
                } else {
                    self?.onError?("Please verify your email before logging in.")
                    try? Auth.auth().signOut()
                }
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
