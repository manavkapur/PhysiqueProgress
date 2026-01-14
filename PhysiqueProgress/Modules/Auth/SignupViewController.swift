import UIKit

final class SignupViewController: UIViewController {

    private let viewModel = SignupViewModel()

    // MARK: - UI (Design System)

    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let cardView = CardView()

    private let emailField = AppTextField(placeholder: "Email")
    private let passwordField = AppTextField(placeholder: "Password")
    private let confirmField = AppTextField(placeholder: "Confirm Password")
    private let signupButton = PrimaryButton(title: "Create Account")

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil
        view.backgroundColor = AppColors.background
        setupUI()
        bindViewModel()
        setupKeyboardUX()
    }

    // MARK: - UI Setup

    private func setupUI() {

        logoImageView.image = UIImage(named: "AppLogo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Create Account"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.text = "Start tracking your physique journey"
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = AppColors.textSecondary
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        cardView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Field configuration (important)

        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.textContentType = .username
        emailField.returnKeyType = .next

        passwordField.isSecureTextEntry = true
        passwordField.textContentType = .newPassword
        passwordField.returnKeyType = .next

        confirmField.isSecureTextEntry = true
        confirmField.textContentType = .newPassword
        confirmField.returnKeyType = .done

        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)

        activityIndicator.color = .white

        // MARK: - Stack

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

        cardView.embed(stack)

        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(cardView)

        // MARK: - Layout

        let logoSize = UIScreen.main.bounds.height * 0.1

        NSLayoutConstraint.activate([

            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: logoSize),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 26),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }

    // MARK: - Keyboard UX

    private func setupKeyboardUX() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        emailField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - ViewModel binding

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
            DispatchQueue.main.async {
                self?.signupButton.isEnabled = !loading
                loading ? self?.activityIndicator.startAnimating()
                        : self?.activityIndicator.stopAnimating()
                self?.cardView.alpha = loading ? 0.7 : 1
            }
        }
    }

    // MARK: - Actions

    @objc private func signupTapped() {
        dismissKeyboard()
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

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmField.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }

        return true
    }
}
