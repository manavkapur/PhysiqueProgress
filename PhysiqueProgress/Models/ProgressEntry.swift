//
//  ProgressEntry.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import Foundation

struct ProgressEntry: Codable {
    let id: String
    let imageFileName: String
    let postureScore: Double
    let symmetryScore: Double
    let proportionScore: Double
    let stabilityScore: Double
    let overallScore: Double
    let date: Date
}
