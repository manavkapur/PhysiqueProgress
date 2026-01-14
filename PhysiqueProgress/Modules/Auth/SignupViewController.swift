//
//  SignupViewController.swift
//  PhysiqueProgress
//

import UIKit

final class SignupViewController: UIViewController {

    private let viewModel = SignupViewModel()

    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let confirmField = UITextField()
    private let signupButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.keyboardType = .emailAddress

        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        confirmField.placeholder = "Confirm Password"
        confirmField.borderStyle = .roundedRect
        confirmField.isSecureTextEntry = true

        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            emailField,
            passwordField,
            confirmField,
            signupButton,
            activityIndicator
        ])

        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 280)
        ])
    }

    private func bindViewModel() {

        viewModel.onSignupSuccess = { [weak self] in
            self?.navigationController?.setViewControllers(
                [VerifyEmailViewController()],
                animated: true
            )
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }

        viewModel.onLoading = { [weak self] loading in
            loading ? self?.activityIndicator.startAnimating()
                    : self?.activityIndicator.stopAnimating()
        }
    }

    @objc private func signupTapped() {
        viewModel.signup(
            email: emailField.text ?? "",
            password: passwordField.text ?? "",
            confirmPassword: confirmField.text ?? ""
        )
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Signup failed",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
