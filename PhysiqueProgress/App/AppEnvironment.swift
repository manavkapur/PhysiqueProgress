//
//  AppEnvironment.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//
import Foundation
import FirebaseAuth

final class AppEnvironment {
    static var pendingDeepLink: DeepLinkRoute?
    
    static var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
