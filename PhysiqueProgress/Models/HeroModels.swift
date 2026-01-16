//
//  HeroModels.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import Foundation

struct HeroModel {
    let score: Int
    let grade: PhysiqueGrade
    let delta: Double
    let coverage: BodyCoverageType
}

struct BreakdownModel {
    let vTaper: Double
    let fatIndex: Double
    let torsoRatio: Double
    let frame: Double
}

struct PostureModel {
    let posture: Double
    let symmetry: Double
    let stability: Double
}

struct InsightModel {
    let title: String
    let strength: String
    let weakness: String
    let action: String
}
