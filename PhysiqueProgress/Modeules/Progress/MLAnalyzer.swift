//
//  MLAnalyzer.swift
//  PhysiqueProgress
//

import UIKit
import Vision

final class MLAnalyzer {

    private let detector = PoseDetector()
    private let calculator = ProgressCalculator()

    private let segmentationManager = BodySegmentationManager()
    private let silhouetteAnalyzer = SilhouetteAnalyzer()
    private let physiqueCalculator = PhysiqueRatioCalculator()
    private let physiqueScorer = PhysiqueScorer()

    // MARK: - Public

    func analyze(
        image: UIImage,
        completion: @escaping (PoseMetrics?) -> Void
    ) {

        let stableImage = normalizedImage(image)
        var results: [PoseMetrics] = []

        func runPass(_ index: Int) {
            singleAnalyze(image: stableImage) { metrics in
                guard let metrics else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }

                results.append(metrics)

                if index == 2 {
                    let averaged = self.average(results)
                    DispatchQueue.main.async { completion(averaged) }
                } else {
                    runPass(index + 1)
                }
            }
        }

        runPass(0)
    }

    // MARK: - One ML pass

    private func singleAnalyze(
        image: UIImage,
        completion: @escaping (PoseMetrics?) -> Void
    ) {

        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        segmentationManager.generateMask(from: cgImage) { [weak self] mask in
            guard let self, let mask else {
                completion(nil)
                return
            }

            // ✅ STEP 1 — silhouette
            guard let silhouette = self.silhouetteAnalyzer.analyze(mask: mask) else {
                completion(nil)
                return
            }

            // ✅ STEP 2 — physique ratios
            let physiqueMetrics = self.physiqueCalculator.calculate(from: silhouette)

            print("""
            ----- PHYSIQUE SHAPE METRICS -----
            V taper: \(physiqueMetrics.vTaper)
            Waist/Hip: \(physiqueMetrics.waistHip)
            FatIndex: \(physiqueMetrics.fatIndex)
            TorsoRatio: \(physiqueMetrics.torsoRatio)
            Shoulder/Thigh: \(physiqueMetrics.shoulderThigh)
            ---------------------------------
            """)

            // ✅ STEP 4 — physique score (obese killer)
            let physiqueScore = self.physiqueScorer.score(from: physiqueMetrics)

            // ✅ STEP 5 — pose
            self.detector.detectPose(in: image) { observation in
                guard let observation else {
                    completion(nil)
                    return
                }

                let poseMetrics = self.calculator.calculateMetrics(
                    from: observation,
                    physiqueScore: Double(physiqueScore)
                )


                // ✅ TEMP wiring (next step we rebuild overall)
                let final = PoseMetrics(
                    postureScore: poseMetrics.postureScore,
                    symmetryScore: poseMetrics.symmetryScore,
                    proportionScore: Double(physiqueScore),   // 🔥 physique replaces proportion
                    stabilityScore: poseMetrics.stabilityScore,
                    overallScore: poseMetrics.overallScore
                )

                completion(final)
            }
        }
    }

    // MARK: - Averaging

    private func average(_ r: [PoseMetrics]) -> PoseMetrics {
        PoseMetrics(
            postureScore: r.map { $0.postureScore }.avg,
            symmetryScore: r.map { $0.symmetryScore }.avg,
            proportionScore: r.map { $0.proportionScore }.avg,
            stabilityScore: r.map { $0.stabilityScore }.avg,
            overallScore: r.map { $0.overallScore }.avg
        )
    }

    // MARK: - Image normalization

    private func normalizedImage(_ image: UIImage) -> UIImage {
        let size = CGSize(width: 512, height: 768)

        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        image.draw(in: CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img ?? image
    }
}

// MARK: - Helpers

extension Array where Element == Double {
    var avg: Double {
        guard !isEmpty else { return 0 }
        return reduce(0, +) / Double(count)
    }
}
