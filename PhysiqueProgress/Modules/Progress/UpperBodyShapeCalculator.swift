//
//  UpperBodyShapeCalculator.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

///
//  UpperBodyShapeCalculator.swift
//  PhysiqueProgress
//
import UIKit

struct UpperBodyShapeMetrics {

    let shoulderChest: CGFloat
    let shoulderWaist: CGFloat
    let chestWaist: CGFloat
    let torsoDominance: CGFloat

    let shoulder: CGFloat
    let chest: CGFloat
    let waist: CGFloat
}

final class UpperBodyShapeCalculator {

    func calculate(from m: UpperBodySilhouetteMetrics) -> UpperBodyShapeMetrics? {

        let safeShoulder = max(m.shoulderWidth, 1)
        let safeChest = max(m.chestWidth, 1)
        guard m.upperWaistWidth > 25 else { return nil }
        let safeWaist = m.upperWaistWidth
        let safeUpper = max(m.upperBodyArea, 1)

        let shoulderChest = safeShoulder / safeChest
        let shoulderWaist = safeShoulder / safeWaist
        let chestWaist = safeChest / safeWaist
        let torsoDominance = m.upperTorsoArea / safeUpper

        print("""
        ---- UPPER RAW METRICS ----
        shoulder px: \(m.shoulderWidth)
        chest px:    \(m.chestWidth)
        waist px:    \(m.upperWaistWidth)

        shoulder/chest: \(shoulderChest)
        shoulder/waist: \(shoulderWaist)
        chest/waist:    \(chestWaist)
        torsoDominance: \(torsoDominance)
        ---------------------------
        """)

        return UpperBodyShapeMetrics(
            shoulderChest: shoulderChest,
            shoulderWaist: shoulderWaist,
            chestWaist: chestWaist,
            torsoDominance: torsoDominance,
            shoulder: m.shoulderWidth,
            chest: m.chestWidth,
            waist: m.upperWaistWidth
        )
    }
}
