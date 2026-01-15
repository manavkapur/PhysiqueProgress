//
//  MLAnalysisResult.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 13/01/26.
//

//
//  MLAnalysisResult.swift
//  PhysiqueProgress
//

enum MLAnalysisResult {

    case full(pose: PoseMetrics, shape: PhysiqueShapeMetrics)
    case upper(pose: PoseMetrics, upper: UpperBodyShapeMetrics)

    // 🔹 Common accessor (so UI doesn’t break)
    var pose: PoseMetrics {
        switch self {
        case .full(let pose, _):
            return pose
        case .upper(let pose, _):
            return pose
        }
    }
}
