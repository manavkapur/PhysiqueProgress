//
//  HomeViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    private let titleLabel = UILabel()
    private let logoView = UIImageView()

    private let card = CardView()
    private let stack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PhysiqueProgress"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {

        let logo = UIImageView(image: UIImage(named: "AppLogo"))
        logo.contentMode = .scaleAspectFit
        logo.heightAnchor.constraint(equalToConstant: 90).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = "PhysiqueProgress"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        let track = ActionCardView(
            icon: UIImage(systemName: "camera.fill"),
            title: "Track Progress",
            subtitle: "Take photos and measurements"
        )
        track.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)

        let history = ActionCardView(
            icon: UIImage(systemName: "calendar"),
            title: "View History",
            subtitle: "See past progress entries"
        )
        history.addTarget(self, action: #selector(historyTapped), for: .touchUpInside)

        let analytics = ActionCardView(
            icon: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            title: "Progress Analytics",
            subtitle: "Analyze your trends and stats"
        )
        analytics.addTarget(self, action: #selector(AnalyticsTapped), for: .touchUpInside)

        let premium = ActionCardView(
            icon: UIImage(systemName: "crown.fill"),
            title: "Go Premium",
            subtitle: "Unlock exclusive features",
            highlight: true
        )
        premium.addTarget(self, action: #selector(subscriptionTapped), for: .touchUpInside)

        let logout = ActionCardView(
            icon: UIImage(systemName: "power"),
            title: "Logout",
            subtitle: "Sign out of your account"
        )
        logout.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)

        logout.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            logo, titleLabel,
            track, history, analytics, premium, logout
        ])

        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    
    private func bindViewModel() {
        viewModel.onNavigate = { [weak self] destination in
            self?.handleNavigation(destination)
        }
    }
    
    @objc private func cameraTapped() {
        viewModel.didSelectCamera()
    }
    
    @objc private func historyTapped() {
        authenticateAndProceed(
            reason: "Unlock your progress history"
        ) { [weak self] in
            self?.viewModel.didSelectHistory()
        }    }
    
    @objc private func subscriptionTapped() {
        viewModel.didSelectSubscription()
    }
    
    @objc private func AnalyticsTapped() {
        authenticateAndProceed(
            reason: "Unlock your progress analytics"
        ) { [weak self] in
            self?.viewModel.didSelectAnalytics()
        }
    }
    
    @objc private func logoutTapped() {
        viewModel.didSelectLogout()
    }
    
    private func makeButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }
    
    private func handleNavigation(
        _ destination: HomeViewModel.Destination
    ){
        switch destination {
            case .camera:
            navigationController?.pushViewController(
                    CameraViewController(),
                    animated: true
            )
            
        case .history:
            navigationController?.pushViewController(
                HistoryViewController(),
                animated: true
            )
            
        case .subscription:
            navigationController?.pushViewController(
                SubscriptionViewController(),
                animated: true
            )
        case .analytics:
            navigationController?.pushViewController(
                ProgressAnalyticsViewController(),
                animated: true
            )

        
        case .logout:
            logout()
        }
    }
    
    private func logout() {
        PushManager.shared.clearTokenOnLogout()

        try? Auth.auth().signOut()
        
        guard let sceneDelegate =
            view.window?.windowScene?.delegate as? SceneDelegate
        else { return }
        
        sceneDelegate.switchToAuth()
    }
    
    private func authenticateAndProceed(
        reason: String,
        onSuccess: @escaping () -> Void
    ) {
        BiometricAuthManager.authenticate(reason: reason) { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if success {
                    onSuccess()
                } else {
                    let alert = UIAlertController(
                        title: "Authentication Failed",
                        message: "Biometric verification required to access this feature.",
                        preferredStyle: .alert
                    )

                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }

    }


}
