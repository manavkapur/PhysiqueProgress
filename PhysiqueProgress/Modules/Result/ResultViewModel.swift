//
//  ResultViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

//
//  ResultViewModel.swift
//

import Foundation

final class ResultViewModel {

    let hero: HeroModel
    let breakdown: BreakdownModel
    let posture: PostureModel
    let insight: InsightModel

    init(entry: ProgressEntry, lastEntry: ProgressEntry?) {

        let delta = lastEntry.map { entry.physiqueScore - $0.physiqueScore } ?? 0

        hero = HeroModel(
            score: Int(entry.physiqueScore),
            grade: PhysiqueGrader.grade(from: entry.physiqueScore),
            delta: delta,
            coverage: entry.coverage
        )

        breakdown = BreakdownModel(
            vTaper: entry.vTaper,
            fatIndex: entry.fatIndex,
            torsoRatio: entry.torsoRatio,
            frame: entry.shoulderThigh
        )

        posture = PostureModel(
            posture: entry.postureScore,
            symmetry: entry.symmetryScore,
            stability: entry.stabilityScore
        )

        insight = InsightEngine.generate(from: entry, last: lastEntry)
    }
}
