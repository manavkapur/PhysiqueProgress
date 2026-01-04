//
//  PhysiqueShapeMetrics.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 12/01/26.
//

import UIKit

struct PhysiqueShapeMetrics {

    // Core ratios
    let vTaper: CGFloat          // shoulder / waist
    let waistHip: CGFloat        // waist / hip
    let fatIndex: CGFloat        // area / height^2
    let torsoRatio: CGFloat     // torsoArea / bodyArea
    let shoulderThigh: CGFloat  // shoulder / thigh

    // Raw (optional, for debugging/graphs)
    let shoulder: CGFloat
    let chest: CGFloat
    let waist: CGFloat
    let hip: CGFloat
    let thigh: CGFloat
}
