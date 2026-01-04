//
//  PhysiqueRatioCalculator.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 12/01/26.
//

import UIKit

final class PhysiqueRatioCalculator {

    func calculate(from m: SilhouetteMetrics) -> PhysiqueShapeMetrics {

        let safeWaist = max(m.waistWidth, 1)
        let safeHip = max(m.hipWidth, 1)
        let safeThigh = max(m.thighWidth, 1)
        let safeArea = max(m.bodyArea, 1)
        let safeHeight = max(m.bodyHeight, 1)

        let vTaper = m.shoulderWidth / safeWaist
        let waistHip = safeWaist / safeHip
        let fatIndex = safeArea / (safeHeight * safeHeight)
        let torsoRatio = m.torsoArea / safeArea
        let shoulderThigh = m.shoulderWidth / safeThigh

        return PhysiqueShapeMetrics(
            vTaper: vTaper,
            waistHip: waistHip,
            fatIndex: fatIndex,
            torsoRatio: torsoRatio,
            shoulderThigh: shoulderThigh,
            shoulder: m.shoulderWidth,
            chest: m.chestWidth,
            waist: m.waistWidth,
            hip: m.hipWidth,
            thigh: m.thighWidth
        )
    }
}
