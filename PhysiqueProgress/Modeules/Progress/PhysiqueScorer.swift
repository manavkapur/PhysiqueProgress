//
//  PhysiqueScorer.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 13/01/26.
//

import UIKit

final class PhysiqueScorer {

    func score(from m: PhysiqueShapeMetrics) -> CGFloat {

        let vScore = vTaperScore(m.vTaper)
        let waistScore = waistControlScore(m.waistHip)
        let torsoScore = torsoDominanceScore(m.torsoRatio)
        let fatScore = fatIndexScore(m.fatIndex)
        let frameScore = frameBalanceScore(m.shoulderThigh)

        let physique =
              0.35 * vScore
            + 0.25 * waistScore
            + 0.20 * torsoScore
            + 0.15 * fatScore
            + 0.05 * frameScore

        print("""
        ===== PHYSIQUE SCORE =====
        V-taper: \(vScore)
        Fat:     \(fatScore)
        Waist:   \(waistScore)
        Torso:   \(torsoScore)
        Frame:   \(frameScore)
        👉 PHYSIQUE SCORE: \(physique)
        ==========================
        """)

        return physique
    }

    // MARK: - Subscores

    private func vTaperScore(_ v: CGFloat) -> CGFloat {
        switch v {
        case let x where x >= 1.55: return 95
        case 1.45..<1.55: return 85
        case 1.30..<1.45: return 65
        case 1.20..<1.30: return 40
        case 1.10..<1.20: return 20
        default: return 5
        }
    }

    private func waistControlScore(_ w: CGFloat) -> CGFloat {
        // >1.1 should crash hard
        let raw = 100 - ((w - 0.82) * 260)
        return clamp(raw, 5, 95)
    }

    private func torsoDominanceScore(_ t: CGFloat) -> CGFloat {
        // obese torsos usually >0.52
        let raw = 100 - ((t - 0.44) * 320)
        return clamp(raw, 5, 95)
    }

    private func fatIndexScore(_ f: CGFloat) -> CGFloat {
        // dynamic harsh curve
        let raw = 110 - (f * 260)
        return clamp(raw, 5, 95)
    }

    private func frameBalanceScore(_ r: CGFloat) -> CGFloat {
        let raw = r * 45
        return clamp(raw, 5, 95)
    }

    private func clamp(_ v: CGFloat, _ minV: CGFloat, _ maxV: CGFloat) -> CGFloat {
        max(minV, min(v, maxV))
    }
}
