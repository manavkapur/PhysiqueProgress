//
//  FirebaseSubscriptionService.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.



import FirebaseAnalytics

final class FirebaseAnalyticsService {

    static let shared = FirebaseAnalyticsService()

    func logPremiumPurchase() {
        Analytics.logEvent("premium_purchase", parameters: nil)
    }

    func logPremiumAnalyticsViewed() {
        Analytics.logEvent("premium_analytics_viewed", parameters: nil)
    }

    func logFreeAnalyticsViewed() {
        Analytics.logEvent("free_analytics_viewed", parameters: nil)
    }
}
