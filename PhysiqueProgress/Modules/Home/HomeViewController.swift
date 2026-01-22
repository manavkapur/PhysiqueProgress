//
//  HomeViewController.swift
//  PhysiqueProgress
//

import UIKit
import FirebaseAuth
import FirebaseCrashlytics

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    // 🔥 Today plan card
    private let todayPlanCard = TodayPlanCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PhysiqueProgress"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadTodayCard),
            name: .todayPlanUpdated,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todayPlanCard.configure()
    }
    
    private func setupUI() {

        // ---------- TODAY PLAN CARD ----------
        
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

//        let logout = ActionCardView(
//            icon: UIImage(systemName: "power"),
//            title: "Logout",
//            subtitle: "Sign out of your account"
//        )
//        logout.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
//        logout.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        let settings = ActionCardView(
            icon: UIImage(systemName: "gearshape.fill"),
            title: "Settings",
            subtitle: "Account, privacy and app settings"
        )
        settings.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            track, history, analytics, settings
        ])

        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        // ---------- LAYOUT ----------

        NSLayoutConstraint.activate([
            todayPlanCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            todayPlanCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todayPlanCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            todayPlanCard.heightAnchor.constraint(equalToConstant: 150),

            stack.topAnchor.constraint(equalTo: todayPlanCard.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Actions

    @objc private func openDailyPlan() {
        navigationController?.pushViewController(PlanEditorViewController(), animated: true)
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
        viewModel.didSelectHistory()
    }
    
    @objc private func AnalyticsTapped() {
        viewModel.didSelectAnalytics()
    }
    
    @objc private func logoutTapped() {
        viewModel.didSelectLogout()
    }
    @objc private func settingsTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }


    private func handleNavigation(_ destination: HomeViewModel.Destination) {

        let entries = ProgressRepository().loadAll()
        let vm = ProgressAnalyticsViewModel(entries: entries)
        let vc = ProgressAnalyticsViewController(viewModel: vm)

        switch destination {
        case .camera:
            navigationController?.pushViewController(CameraViewController(), animated: true)

        case .history:
            navigationController?.pushViewController(HistoryViewController(), animated: true)

        case .analytics:
            navigationController?.pushViewController(vc, animated: true)

        case .logout:
            logout()

        default:
            break
        }
    }
    
    private func logout() {
        PushManager.shared.clearTokenOnLogout()
        try? Auth.auth().signOut()
        
        guard let sceneDelegate =
                view.window?.windowScene?.delegate as? SceneDelegate else { return }
        
        sceneDelegate.switchToAuth()
    }

    @objc private func reloadTodayCard() {
        todayPlanCard.configure()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
