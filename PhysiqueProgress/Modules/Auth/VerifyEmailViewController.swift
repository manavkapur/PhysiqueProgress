//
//  VerifyEmailViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 14/01/26.
//

import UIKit
import FirebaseAuth

final class VerifyEmailViewController: UIViewController {

    private let authService = AuthService()

    private let infoLabel = UILabel()
    private let refreshButton = UIButton(type: .system)
    private let resendButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    private let activity = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Verify Email"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {

        infoLabel.text = """
We’ve sent a verification email.

Please open your email and click the verification link.

After verifying, tap Refresh.
"""
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0

        refreshButton.setTitle("Refresh Status", for: .normal)
        resendButton.setTitle("Resend Email", for: .normal)
        logoutButton.setTitle("Logout", for: .normal)

        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
        resendButton.addTarget(self, action: #selector(resendTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            infoLabel,
            refreshButton,
            resendButton,
            logoutButton,
            activity
        ])

        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

    @objc private func refreshTapped() {
        activity.startAnimating()

        Auth.auth().currentUser?.reload { [weak self] error in
            DispatchQueue.main.async {
                self?.activity.stopAnimating()

                if let error {
                    self?.showAlert(error.localizedDescription)
                    return
                }

                if Auth.auth().currentUser?.isEmailVerified == true {
                    self?.switchToHome()
                } else {
                    self?.showAlert("Still not verified. Please check your email.")
                }
            }
        }
    }

    @objc private func resendTapped() {
        authService.resendVerification { [weak self] error in
            DispatchQueue.main.async {
                if let error {
                    self?.showAlert(error.localizedDescription)
                } else {
                    self?.showAlert("Verification email sent again.")
                }
            }
        }
    }

    @objc private func logoutTapped() {
        try? Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    }

    private func switchToHome() {
        guard let sceneDelegate =
            view.window?.windowScene?.delegate as? SceneDelegate
        else { return }

        sceneDelegate.switchToHome()
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let user = Auth.auth().currentUser, user.isEmailVerified {
            switchToHome()
        }
    }

}
