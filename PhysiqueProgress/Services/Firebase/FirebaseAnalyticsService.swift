//
//  FirebaseAnalyticsService.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//


import FirebaseAnalytics

final class FirebaseAnalyticsService {

    static let shared = FirebaseAnalyticsService()

    func logPremiumPurchase(productId: String) {
        Analytics.logEvent("premium_purchase", parameters: [
            "product_id": productId
        ])
    }

    func logPremiumRestore() {
        Analytics.logEvent("premium_restore", parameters: nil)
    }

    func logSubscriptionActive() {
        Analytics.setUserProperty("true", forName: "is_premium")
        Analytics.logEvent("premium_active", parameters: nil)
    }

    func logSubscriptionInactive() {
        Analytics.setUserProperty("false", forName: "is_premium")
        Analytics.logEvent("premium_inactive", parameters: nil)
    }

    func logPremiumAnalyticsViewed() {
        Analytics.logEvent("premium_analytics_viewed", parameters: nil)
    }

    func logFreeAnalyticsViewed() {
        Analytics.logEvent("free_analytics_viewed", parameters: nil)
    }
}
