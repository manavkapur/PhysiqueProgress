//
//  ProgressCalculator.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import Vision

struct PoseMetrics {
    let postureScore: Double
    let symmetryScore: Double
    let physiqueScore: Double   // now = physique score
    let stabilityScore: Double
    let overallScore: Double
}

final class ProgressCalculator {

    private var lastPhysiqueScore: Double?

    // 🔥 MAIN ENTRY — physique comes from silhouette engine now
    func calculateMetrics(from observation: VNHumanBodyPoseObservation,
                          physiqueScore: Double) -> PoseMetrics {

        guard let p = try? observation.recognizedPoints(.all) else {
            return zeroMetrics()
        }

        let posture = min(max(postureScore(p), 0), 100)
        let symmetry = min(max(symmetryScore(p), 0), 100)
        let stability = min(max(stabilityScore(p), 0), 100)

        // 🔹 Smooth physique
        var physique = physiqueScore
        if let last = lastPhysiqueScore {
            physique = (physique * 0.8) + (last * 0.2)
        }
        lastPhysiqueScore = physique

        // 🔥 FINAL OVERALL (physique-dominant)
        var overall =
            (physique * 0.60) +
            (posture * 0.15) +
            (symmetry * 0.15) +
            (stability * 0.10)

        // Soft limiter: posture can't fake physique
        overall = min(overall, physique + 10)

        // No perfect humans
        overall = min(overall, 92)

        return PoseMetrics(
            postureScore: posture,
            symmetryScore: symmetry,
            physiqueScore: physique,   // 🔥 physique lives here now
            stabilityScore: stability,
            overallScore: overall
        )
    }

    private func zeroMetrics() -> PoseMetrics {
        PoseMetrics(postureScore: 0, symmetryScore: 0, physiqueScore: 0, stabilityScore: 0, overallScore: 0)
    }

    // MARK: - POSTURE

    private func postureScore(_ p: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) -> Double {

        guard
            let nose = p[.nose],
            let ls = p[.leftShoulder], let rs = p[.rightShoulder],
            let lh = p[.leftHip], let rh = p[.rightHip]
        else { return 50 }

        let shoulderMid = (ls.x + rs.x) / 2
        let hipMid = (lh.x + rh.x) / 2

        let drift = abs(nose.x - shoulderMid) + abs(shoulderMid - hipMid)
        let score = 1 - min(drift * 3.0, 1)

        return 40 + score * 50
    }

    // MARK: - SYMMETRY

    private func symmetryScore(_ p: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) -> Double {

        guard
            let ls = p[.leftShoulder], let rs = p[.rightShoulder],
            let le = p[.leftElbow], let re = p[.rightElbow],
            let lh = p[.leftHip], let rh = p[.rightHip]
        else { return 50 }

        let diffs = [
            abs(ls.y - rs.y),
            abs(le.y - re.y),
            abs(lh.y - rh.y)
        ]

        let avg = diffs.reduce(0, +) / Double(diffs.count)
        let score = 1 - min(avg * 4.0, 1)

        return 45 + score * 45
    }

    // MARK: - STABILITY

    private func stabilityScore(_ p: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) -> Double {

        guard
            let la = p[.leftAnkle], let ra = p[.rightAnkle]
        else { return 40 }

        let diff = abs(la.x - ra.x)
        let score = 1 - min(diff * 1.8, 1)

        return 40 + score * 50
    }
}
