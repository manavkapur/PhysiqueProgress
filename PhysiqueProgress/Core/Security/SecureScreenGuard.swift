//
//  SecureScreenGuard.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import UIKit
import Foundation
import UIKit

import UIKit

final class SecureScreenGuard {

    private static var overlayWindow: UIWindow?

    static func enable() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    @objc private static func appWillResignActive() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        let window = UIWindow(windowScene: scene)
        window.frame = UIScreen.main.bounds
        window.windowLevel = .alert + 1

        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = window.bounds

        window.addSubview(blurView)
        window.makeKeyAndVisible()

        overlayWindow = window
    }


    @objc private static func appDidBecomeActive() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }
}
