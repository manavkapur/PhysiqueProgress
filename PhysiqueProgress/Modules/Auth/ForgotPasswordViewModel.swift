//
//  ForgotPasswordViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 14/01/26.
//

// ForgotPasswordViewModel.swift

import Foundation

final class ForgotPasswordViewModel {

    private let authService = AuthService()

    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    func sendReset(email: String) {

        guard !email.isEmpty else {
            onError?("Email is required")
            return
        }

        onLoading?(true)

        authService.sendPasswordReset(email: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)

                switch result {
                case .success:
                    self?.onSuccess?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
