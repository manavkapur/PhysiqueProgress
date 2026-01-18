//
//  PremiumGate.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 18/01/26.
//

import Foundation

final class PremiumGate {

    static let freeDailyPhotoLimit = 2

    static func canAddNewPhoto(
        isPremium: Bool,
        todayPhotoCount: Int
    ) -> Bool {

        if isPremium { return true }
        return todayPhotoCount < freeDailyPhotoLimit
    }
}
