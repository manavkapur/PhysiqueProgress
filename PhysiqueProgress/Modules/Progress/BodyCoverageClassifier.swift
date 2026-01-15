import Vision

enum BodyCoverage {
    case full
    case upper
    case invalid
}
final class BodyCoverageClassifier {

    func classify(
        _ obs: VNHumanBodyPoseObservation?,
        hasBodyMask: Bool
    ) -> BodyCoverage {

        // ---------- POSE PATH ----------
        if let obs, let p = try? obs.recognizedPoints(.all) {

            func pt(_ j: VNHumanBodyPoseObservation.JointName,
                    _ min: Float = 0.18) -> VNRecognizedPoint? {
                guard let v = p[j], v.confidence >= min else { return nil }
                return v
            }

            let ls = pt(.leftShoulder)
            let rs = pt(.rightShoulder)

            let la = pt(.leftAnkle, 0.12)
            let ra = pt(.rightAnkle, 0.12)

            if let l = ls, let r = rs {
                if let ankle = la ?? ra {
                    let span = abs(((l.y + r.y)/2) - ankle.y)
                    if span > 0.42 {
                        print("🔥 Full body (pose)")
                        return .full
                    }
                }

                print("🪞 Upper body (pose)")
                return .upper
            }
        }

        // ---------- SILHOUETTE FALLBACK ----------
        if hasBodyMask {
            print("🪞 Upper body (silhouette fallback)")
            return .upper
        }

        // ---------- INVALID ----------
        return .invalid
    }
}
