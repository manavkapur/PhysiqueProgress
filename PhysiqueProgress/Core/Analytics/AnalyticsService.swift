//
//  AnalyticsService.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 14/01/26.
//

import FirebaseAnalytics

final class AnalyticsService {
    static let shared = AnalyticsService()
    private init() {}

    func log(_ name: String, _ params: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }

    func setPremium(_ isPremium: Bool) {
        Analytics.setUserProperty(isPremium ? "true" : "false", forName: "is_premium")
    }
}
