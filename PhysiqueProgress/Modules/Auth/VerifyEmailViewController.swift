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

    // MARK: - UI (Design System)

    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let cardView = CardView()

    private let refreshButton = PrimaryButton(title: "Refresh Status")
    private let resendButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    private let activity = UIActivityIndicatorView(style: .medium)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil
        view.backgroundColor = AppColors.background
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {

        // Logo
        logoImageView.image = UIImage(named: "AppLogo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        // Title
        titleLabel.text = "Verify your email"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Subtitle
        subtitleLabel.text = """
We’ve sent a verification link to your email.

Open your inbox and tap the link to activate your account.
"""
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = AppColors.textSecondary
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Buttons
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)

        resendButton.setTitle("Resend email", for: .normal)
        resendButton.setTitleColor(AppColors.primary, for: .normal)
        resendButton.addTarget(self, action: #selector(resendTapped), for: .touchUpInside)

        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        activity.color = .white
        activity.hidesWhenStopped = true

        // Stack inside card
        let stack = UIStackView(arrangedSubviews: [
            subtitleLabel,
            refreshButton,
            resendButton,
            logoutButton,
            activity
        ])

        stack.axis = .vertical
        stack.spacing = 18
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        // Add to screen
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(cardView)

        // Layout
        let logoSize = UIScreen.main.bounds.height * 0.1

        NSLayoutConstraint.activate([

            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: logoSize),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }

    // MARK: - Actions

    @objc private func refreshTapped() {
        activity.startAnimating()
        refreshButton.isEnabled = false

        Auth.auth().currentUser?.reload { [weak self] error in
            DispatchQueue.main.async {
                self?.activity.stopAnimating()
                self?.refreshButton.isEnabled = true

                if let error {
                    self?.showAlert(error.localizedDescription)
                    return
                }

                _ = Auth.auth().currentUser?.isEmailVerified

                if Auth.auth().currentUser?.isEmailVerified == true {
                    // SessionManager will handle redirect
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

    // MARK: - Routing

    private func switchToHome() {
        guard let sceneDelegate =
            view.window?.windowScene?.delegate as? SceneDelegate
        else { return }

        sceneDelegate.switchToHome()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let user = Auth.auth().currentUser, user.isEmailVerified {
            switchToHome()
        }
    }

    // MARK: - Alert

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
