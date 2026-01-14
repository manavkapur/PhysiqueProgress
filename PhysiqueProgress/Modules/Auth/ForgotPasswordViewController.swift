//
//  ForgotPasswordViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 14/01/26.
//

// ForgotPasswordViewController.swift

import UIKit

final class ForgotPasswordViewController: UIViewController {

    private let viewModel = ForgotPasswordViewModel()

    private let infoLabel = UILabel()
    private let emailField = UITextField()
    private let sendButton = UIButton(type: .system)
    private let activity = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forgot Password"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }

    private func setupUI() {

        infoLabel.text = "Enter your email. We’ll send you a password reset link."
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0

        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.keyboardType = .emailAddress

        sendButton.setTitle("Send Reset Link", for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            infoLabel,
            emailField,
            sendButton,
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

    private func bindViewModel() {

        viewModel.onSuccess = { [weak self] in
            self?.showAlert(
                "Reset email sent. Please check your inbox.",
                popOnOK: true
            )
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }

        viewModel.onLoading = { [weak self] loading in
            loading ? self?.activity.startAnimating()
                    : self?.activity.stopAnimating()
        }
    }

    @objc private func sendTapped() {
        viewModel.sendReset(email: emailField.text ?? "")
    }

    private func showAlert(_ message: String, popOnOK: Bool = false) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if popOnOK {
                self.navigationController?.popViewController(animated: true)
            }
        })
        present(alert, animated: true)
    }
}
