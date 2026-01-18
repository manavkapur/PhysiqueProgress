import UIKit

final class DeepLinkManager {

    static let shared = DeepLinkManager()
    private init() {}

    func handle(url: URL, window: UIWindow?) {

        let deepLink: DeepLink
        if let schemeLink = DeepLink(schemeURL: url) {
            deepLink = schemeLink
        } else {
            deepLink = DeepLink(url: url)
        }

        if !AppEnvironment.isUserLoggedIn {
            AppEnvironment.pendingDeepLink = deepLink.route
            return
        }

        route(deepLink.route, window: window)
    }

    func handleAfterLogin(route: DeepLinkRoute, window: UIWindow?) {
        self.route(route, window: window)
    }



    // MARK: - Core router

    private func route(_ route: DeepLinkRoute, window: UIWindow?) {
        let entries = ProgressRepository().loadAll()
        let vm = ProgressAnalyticsViewModel(entries: entries)
        let vc = ProgressAnalyticsViewController(viewModel: vm)
        guard
            let nav = window?.rootViewController as? UINavigationController
        else { return }

        switch route {

        case .progress:
            nav.pushViewController(vc, animated: true)

        case .history:
            nav.pushViewController(HistoryViewController(), animated: true)

        case .unknown:
            break
        }
    }
}
