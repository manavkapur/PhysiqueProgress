//
//  HomeViewController.swift
//  PhysiqueProgress
//

import UIKit
import FirebaseAuth



class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    // 🔥 NEW — Today plan card
    private let todayPlanCard = TodayPlanCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PhysiqueProgress"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
        
        // ✅ LIVE refresh when plan changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadTodayCard),
            name: .todayPlanUpdated,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todayPlanCard.configure()   // 🔄 refresh when coming back
    }
    
    private func setupUI() {

        // ---------- TODAY PLAN CARD (replaces logo area) ----------
        
        todayPlanCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayPlanCard)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openDailyPlan))
        todayPlanCard.addGestureRecognizer(tap)
        todayPlanCard.isUserInteractionEnabled = true

        // ---------- ACTION CARDS ----------

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
            track, history, analytics, premium, logout
        ])

        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)



        // ---------- LAYOUT ----------

        NSLayoutConstraint.activate([
            
            // Today plan card
            todayPlanCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            todayPlanCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todayPlanCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            todayPlanCard.heightAnchor.constraint(equalToConstant: 150),

            // Menu stack
            stack.topAnchor.constraint(equalTo: todayPlanCard.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Today Plan Navigation
    
    @objc private func openDailyPlan() {
        navigationController?.pushViewController(
            PlanEditorViewController(),
            animated: true
        )
    }

    // MARK: - Bind VM
    
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
        }
    }
    
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
        
        let entries = ProgressRepository().loadAll()
        let vm = ProgressAnalyticsViewModel(entries: entries)
        let vc = ProgressAnalyticsViewController(viewModel: vm)

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
                vc,
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
    @objc private func reloadTodayCard() {
        todayPlanCard.configure()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
