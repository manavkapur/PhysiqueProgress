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
    let date: Date

    // USER / CAPTURE METADATA
    let height: Double
    let weight: Double?
    let poseQuality: Double   // derived from posture+stability

    // FINAL SCORES
    let overallScore: Double
    let physiqueScore: Double

    // POSE QUALITY
    let postureScore: Double
    let symmetryScore: Double
    let stabilityScore: Double

    // TRUE BODY SHAPE
    let vTaper: Double
    let waistHip: Double
    let fatIndex: Double
    let torsoRatio: Double
    let shoulderThigh: Double

    // SYSTEM
    let weekOfYear: Int
    let engineVersion: String
}
