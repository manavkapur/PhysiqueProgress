//
//  DeepLinkManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import UIKit

final class DeepLinkManager {

    static let shared = DeepLinkManager()

    private init() {}

    func handle(url: URL, window: UIWindow?) {
        let deepLink =
            DeepLink(url: url) ??
            DeepLink(schemeURL: url)

        guard let deepLink else { return }

        route(deepLink.route, window: window)
    }

    private func route(
        _ route: DeepLinkRoute,
        window: UIWindow?
    ) {
        guard
            let nav = window?.rootViewController
                as? UINavigationController
        else { return }

        switch route {

        case .progress:
            nav.pushViewController(
                ProgressViewController(),
                animated: true
            )

        case .premium:
            nav.pushViewController(
                SubscriptionViewController(),
                animated: true
            )

        case .history:
            nav.pushViewController(
                HistoryViewController(),
                animated: true
            )

        case .unknown:
            break
        }
    }
}
