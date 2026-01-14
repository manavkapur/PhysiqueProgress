//
//  SessionManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 14/01/26.
//
import FirebaseAuth
import UIKit

final class SessionManager {

    static let shared = SessionManager()
    private init() {}

    private var handle: AuthStateDidChangeListenerHandle?

    func start(window: UIWindow?) {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            guard let window else { return }

            if let user {
                // ✅ Apple users OR verified email users go home
                if user.providerData.contains(where: { $0.providerID == "apple.com" }) ||
                   user.isEmailVerified {

                    self.showHome(window: window)

                } else {
                    // ❌ email user but not verified
                    self.showVerifyEmail(window: window)
                }

            } else {
                // ❌ logged out
                self.showLogin(window: window)
            }
        }
    }

    private func showHome(window: UIWindow) {
        let nav = UINavigationController(rootViewController: HomeViewController())
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    private func showLogin(window: UIWindow) {
        let nav = UINavigationController(rootViewController: LoginViewController())
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    private func showVerifyEmail(window: UIWindow) {
        let nav = UINavigationController(rootViewController: VerifyEmailViewController())
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
