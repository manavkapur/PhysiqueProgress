import UIKit

final class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()

    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none

        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            emailField,
            passwordField,
            loginButton,
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
        viewModel.onLoginSuccess = { [weak self] in
            NotificationCoordinator.shared.setupAfterLogin()
            self?.switchToHome()
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }

        viewModel.onLoading = { [weak self] loading in
            loading ? self?.activityIndicator.startAnimating()
                    : self?.activityIndicator.stopAnimating()
        }
    }

    @objc private func loginTapped() {
        viewModel.login(
            email: emailField.text ?? "",
            password: passwordField.text ?? ""
        )
    }
    
    private func switchToHome() {
        guard let sceneDelegate =
            view.window?.windowScene?.delegate as? SceneDelegate
        else { return }

        sceneDelegate.switchToHome()
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }


}
