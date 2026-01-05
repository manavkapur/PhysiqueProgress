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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PhysiqueProgress"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        let cameraBtb = makeButton(
            title: "Track Progress",
            action: #selector(cameraTapped)
        )
        
        let historyBtb = makeButton(
            title: "History",
            action: #selector(historyTapped)
        )
        
        let premiumBtn = makeButton(
            title: "Go Premium",
            action: #selector(subscriptionTapped)
        )
        
        let analyticsBtn = makeButton(
            title: "Progress Analytics",
            action: #selector(AnalyticsTapped)
        )
        
        let logoutBtn = makeButton(
            title: "Logout",
            action: #selector(logoutTapped)
        )

        
        
        let stack = UIStackView(arrangedSubviews: [
            cameraBtb,
            historyBtb,
            analyticsBtn,
            premiumBtn,
            logoutBtn
        ])
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 300)
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
                ProgressViewController(),
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
        BiometricAuthManager.authenticate(reason: reason) { success in
            DispatchQueue.main.async {
                if success {
                    onSuccess()
                }
            }
        }
    }


}
