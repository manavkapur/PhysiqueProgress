import UIKit

final class ForgotPasswordViewController: UIViewController {

    private let viewModel = ForgotPasswordViewModel()

    // MARK: - UI (Design System)

    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let cardView = CardView()

    private let emailField = AppTextField(placeholder: "Email")
    private let sendButton = PrimaryButton(title: "Send reset link")
    private let activity = UIActivityIndicatorView(style: .medium)

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

        titleLabel.text = "Reset password"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.text = "Enter your email and we’ll send you a reset link."
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = AppColors.textSecondary
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Field config
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.textContentType = .username
        emailField.returnKeyType = .done

        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)

        activity.color = .white
        activity.hidesWhenStopped = true

        // Stack
        let stack = UIStackView(arrangedSubviews: [
            subtitleLabel,
            emailField,
            sendButton,
            activity
        ])

        stack.axis = .vertical
        stack.spacing = 18
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

    // MARK: - Keyboard UX

    private func setupKeyboardUX() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        emailField.delegate = self
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - ViewModel

    private func bindViewModel() {

        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(
                    "Reset email sent. Please check your inbox.",
                    popOnOK: true
                )
            }
        }

        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(message)
            }
        }

        viewModel.onLoading = { [weak self] loading in
            DispatchQueue.main.async {
                self?.sendButton.isEnabled = !loading
                loading ? self?.activity.startAnimating()
                        : self?.activity.stopAnimating()
                self?.cardView.alpha = loading ? 0.7 : 1
            }
        }
    }

    // MARK: - Actions

    @objc private func sendTapped() {
        dismissKeyboard()
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

// MARK: - UITextFieldDelegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
