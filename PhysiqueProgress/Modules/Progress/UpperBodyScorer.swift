//
//  UpperBodyScorer.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//
//
//  UpperBodyScorer.swift
//  PhysiqueProgress
//
import UIKit

final class UpperBodyScorer {

    func score(from m: UpperBodyShapeMetrics) -> CGFloat {

        // 🔥 V taper (king)
        let taper = normalize(m.chestWaist, 1.28, 1.95)

        // 🔥 Frame (delts vs chest)
        let shoulderDominance = normalize(1.00 - m.shoulderChest, 0.02, 0.16)

        // 🔥 Mass density (upper torso fill)
        let torso = normalize(m.torsoDominance, 0.72, 0.86)

        let upperBody =
              0.50 * (taper * 100)
            + 0.30 * (shoulderDominance * 100)
            + 0.20 * (torso * 100)

        print("""
        ===== UPPER BODY SCORE =====
        Chest/Waist (V):     \(taper * 100)
        Shoulder dominance: \(shoulderDominance * 100)
        Torso density:      \(torso * 100)
        👉 UPPER BODY SCORE: \(upperBody)
        ============================
        """)
        if m.chestWaist < 1.05 {
            return clamp(8 + (m.chestWaist * 12), 5, 22)
        }
        return clamp(upperBody, 8, 95)
    }

    private func normalize(_ v: CGFloat, _ min: CGFloat, _ max: CGFloat) -> CGFloat {
        clamp((v - min) / (max - min), 0, 1)
    }

    private func clamp(_ v: CGFloat, _ minV: CGFloat, _ maxV: CGFloat) -> CGFloat {
        max(minV, min(v, maxV))
    }
}
