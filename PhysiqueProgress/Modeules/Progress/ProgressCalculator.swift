import Vision

struct PoseMetrics {
    let postureScore: Double
    let symmetryScore: Double
    let proportionScore: Double
    let stabilityScore: Double
    let overallScore: Double
}

final class ProgressCalculator {

    private var lastPhysiqueScore: Double?

    func calculateMetrics(from observation: VNHumanBodyPoseObservation,
                          silhouette: SilhouetteMetrics) -> PoseMetrics {

        guard let p = try? observation.recognizedPoints(.all) else {
            return zeroMetrics()
        }

        let posture = min(max(postureScore(p), 0), 100)
        let symmetry = min(max(symmetryScore(p), 0), 100)
        let stability = min(max(stabilityScore(p), 0), 100)


        var physique = physiqueScore(from: silhouette)
        
        if let last = lastPhysiqueScore {
            physique = (physique * 0.8) + (last * 0.2)
        }

        lastPhysiqueScore = physique
   // 🔥 main driver

        var overall =
            (physique * 0.75) +
            (posture * 0.08) +
            (symmetry * 0.09) +
            (stability * 0.08)

        // Soft limiter: posture can't fake a big physique jump
        overall = min(overall, physique + 10)

        // No perfect humans
        overall = min(overall, 92)


        return PoseMetrics(
            postureScore: posture,
            symmetryScore: symmetry,
            proportionScore: physique,
            stabilityScore: stability,
            overallScore: overall
        )
    }

    private func zeroMetrics() -> PoseMetrics {
        PoseMetrics(postureScore: 0, symmetryScore: 0, proportionScore: 0, stabilityScore: 0, overallScore: 0)
    }

    // MARK: - POSTURE (alignment only)

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

        return 40 + score * 50   // 40–90 range
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

        return 45 + score * 45   // 45–90 range
    }

    // MARK: - PROPORTION (FIXED — NO MORE 100s)

    func physiqueScore(from s: SilhouetteMetrics) -> Double {

        guard s.waistWidth > 0, s.hipWidth > 0, s.upperArea > 1000  else { return 30 }

        let vTaper = s.shoulderWidth / s.waistWidth
        let torsoBalance = s.shoulderWidth / s.hipWidth
        let upperMass = s.upperArea / max(s.lowerArea, 1)

        let v = clamp((vTaper - 1.1) / 0.6)
        let t = clamp((torsoBalance - 1.0) / 0.4)
        let u = clamp((upperMass - 0.95) / 0.35)

        let physique = (v * 0.5) + (t * 0.25) + (u * 0.25)

        return 25 + physique * 60   // 🔥 25 → 85 real human band
    }

    private func clamp(_ v: Double) -> Double {
        max(0, min(v, 1))
    }


    // MARK: - STABILITY

    private func stabilityScore(_ p: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) -> Double {

        guard
            let la = p[.leftAnkle], let ra = p[.rightAnkle]
        else { return 40 }

        let diff = abs(la.x - ra.x)
        let score = 1 - min(diff * 1.8, 1)

        return 40 + score * 50   // 40–90
    }

    // MARK: - UTIL

    private func distance(_ a: VNRecognizedPoint, _ b: VNRecognizedPoint) -> Double {
        sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }


}
