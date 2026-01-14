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
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self, let window else { return }

            DispatchQueue.main.async {

                if let user {

                    // 🔥 FIRESTORE PROFILE SETUP (HERE)
                    UserProfileService.shared.createIfNeeded(user: user)
                    UserProfileService.shared.updateLastLogin(user: user)

                    let isAppleUser =
                        user.providerData.contains { $0.providerID == "apple.com" }

                    if user.isEmailVerified || isAppleUser {
                        self.showHome(window: window)
                    } else {
                        self.showVerifyEmail(window: window)
                    }

                } else {
                    self.showLogin(window: window)
                }
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
    private func isAppleUser(_ user: User) -> Bool {
        user.providerData.contains { $0.providerID == "apple.com" }
    }
}
