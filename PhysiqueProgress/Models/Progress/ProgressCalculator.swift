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
    let proportionScore: Double
    let stabilityScore: Double
    let overallScore: Double
}

final class ProgressCalculator {

    func calculateMetrics(
        from observation: VNHumanBodyPoseObservation
    ) -> PoseMetrics {

        guard let points = try? observation.recognizedPoints(.all) else {
            return zeroMetrics()
        }

        let posture = postureScore(points)
        let symmetry = symmetryScore(points)
        let proportion = proportionScore(points)
        let stability = stabilityScore(points)

        let overall = (
            posture * 0.35 +
            symmetry * 0.25 +
            proportion * 0.25 +
            stability * 0.15
        )

        return PoseMetrics(
            postureScore: posture,
            symmetryScore: symmetry,
            proportionScore: proportion,
            stabilityScore: stability,
            overallScore: overall
        )
    }

    private func zeroMetrics() -> PoseMetrics {
        PoseMetrics(
            postureScore: 0,
            symmetryScore: 0,
            proportionScore: 0,
            stabilityScore: 0,
            overallScore: 0
        )
    }
    
    private func postureScore(
        _ p: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]
    ) -> Double {

        guard
            let ls = p[.leftShoulder],
            let rs = p[.rightShoulder],
            let lh = p[.leftHip],
            let rh = p[.rightHip]
        else { return 0 }

        let shoulderDiff = abs(ls.y - rs.y)
        let hipDiff = abs(lh.y - rh.y)

        let raw = 1 - min(shoulderDiff + hipDiff, 1)
        return raw * 100
    }

    private func symmetryScore(
        _ p: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]
    ) -> Double {

        guard
            let ls = p[.leftShoulder],
            let rs = p[.rightShoulder],
            let le = p[.leftElbow],
            let re = p[.rightElbow]
        else { return 0 }

        let leftArm = distance(ls, le)
        let rightArm = distance(rs, re)

        let diff = abs(leftArm - rightArm)
        let raw = 1 - min(diff, 1)
        return raw * 100
    }

    private func proportionScore(
        _ p: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]
    ) -> Double {

        guard
            let ls = p[.leftShoulder],
            let rs = p[.rightShoulder],
            let lh = p[.leftHip],
            let rh = p[.rightHip]
        else { return 0 }

        let shoulderWidth = distance(ls, rs)
        let hipWidth = distance(lh, rh)

        guard hipWidth > 0 else { return 0 }

        let ratio = shoulderWidth / hipWidth
        let normalized = min(max((ratio - 1) * 50, 0), 100)
        return normalized
    }

    private func stabilityScore(
        _ p: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]
    ) -> Double {

        guard
            let la = p[.leftAnkle],
            let ra = p[.rightAnkle]
        else { return 0 }

        let diff = abs(la.x - ra.x)
        let raw = 1 - min(diff, 1)
        return raw * 100
    }

    private func distance(
        _ a: VNRecognizedPoint,
        _ b: VNRecognizedPoint
    ) -> Double {
        sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }

}

