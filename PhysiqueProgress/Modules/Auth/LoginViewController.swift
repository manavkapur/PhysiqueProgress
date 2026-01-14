import UIKit
import AuthenticationServices


final class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()

    private let signupButton = UIButton(type: .system)
    private let forgotButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let cardView = CardView()

    private let emailField = AppTextField(placeholder: "Email")
    private let passwordField = AppTextField(placeholder: "Password")
    private let loginButton = PrimaryButton(title: "Log In")

    private let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil
        view.backgroundColor = AppColors.background
        setupUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        cardView.alpha = 0
        appleButton.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseOut) {

            self.cardView.alpha = 1
            self.appleButton.alpha = 1
            self.logoImageView.transform = .identity
        }
    }


    private func setupUI() {

        // MARK: - Logo
        logoImageView.image = UIImage(named: "AppLogo") // or AppLogo
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Title
        titleLabel.text = "PhysiqueProgress"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Secondary buttons
        forgotButton.setTitle("Forgot password?", for: .normal)
        forgotButton.setTitleColor(AppColors.textSecondary, for: .normal)
        forgotButton.addTarget(self, action: #selector(forgotTapped), for: .touchUpInside)

        signupButton.setTitle("Don’t have an account? Sign up", for: .normal)
        signupButton.setTitleColor(AppColors.primary, for: .normal)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        appleButton.cornerRadius = 12
        appleButton.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        appleButton.heightAnchor.constraint(equalToConstant: 52).isActive = true

        activityIndicator.color = .white

        // MARK: - Card stack
        let stack = UIStackView(arrangedSubviews: [
            emailField,
            passwordField,
            loginButton,
            forgotButton,
            signupButton
        ])

        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(stack)

        // MARK: - Add subviews
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(cardView)
        view.addSubview(appleButton)

        // MARK: - Adaptive logo size
        let logoSize = UIScreen.main.bounds.height * 0.11

        NSLayoutConstraint.activate([

            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
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
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),

            appleButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        appleButton.translatesAutoresizingMaskIntoConstraints = false

    }


    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] in

            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("🔔 Authorization status:", settings.authorizationStatus.rawValue)
            }

            NotificationCoordinator.shared.setupAfterLogin()

            // ✅ ONLY deep link continuation (optional)
            if let scene = self?.view.window?.windowScene,
               let sceneDelegate = scene.delegate as? SceneDelegate,
               let route = AppEnvironment.pendingDeepLink {

                DeepLinkManager.shared.handleAfterLogin(
                    route: route,
                    window: sceneDelegate.window
                )

                AppEnvironment.pendingDeepLink = nil
            }
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }

        viewModel.onLoading = { [weak self] loading in
            DispatchQueue.main.async {
                self?.loginButton.isEnabled = !loading
                loading ? self?.activityIndicator.startAnimating()
                        : self?.activityIndicator.stopAnimating()
            }
            self?.cardView.alpha = loading ? 0.7 : 1
        }
    }


    @objc private func loginTapped() {
        viewModel.login(
            email: emailField.text ?? "",
            password: passwordField.text ?? ""
        )
    }
    
    @objc private func signupTapped() {
        navigationController?.pushViewController(
            SignupViewController(),
            animated: true
        )
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

    @objc private func forgotTapped() {
        navigationController?.pushViewController(
            ForgotPasswordViewController(),
            animated: true
        )
    }
    @objc private func appleLoginTapped() {
        AppleAuthManager.shared.startSignInWithAppleFlow()
    }

}
