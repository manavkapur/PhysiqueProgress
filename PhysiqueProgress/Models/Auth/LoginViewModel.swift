//
//  LoginViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

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
                self?.onLoginSuccess?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
