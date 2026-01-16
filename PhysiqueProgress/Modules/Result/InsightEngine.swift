//
//  InsightEngine.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

final class InsightEngine {

    static func generate(from entry: ProgressEntry,
                         last: ProgressEntry?) -> InsightModel {

        let strength: String
        let weakness: String

        if entry.vTaper > 1.45 {
            strength = "Strong V-taper and shoulder structure"
        } else {
            strength = "Good base frame, improving aesthetics"
        }

        if entry.fatIndex > 0.42 {
            weakness = "Fat levels masking physique shape"
        } else if entry.torsoRatio > 0.50 {
            weakness = "Waist control needs improvement"
        } else {
            weakness = "No major weakness detected"
        }

        let action: String =
            entry.coverage == .upper
            ? "Do a full body scan this week to unlock fat tracking"
            : "Maintain consistency — scan again in 3 days"

        return InsightModel(
            title: "Physique Insight",
            strength: strength,
            weakness: weakness,
            action: action
        )
    }
}
