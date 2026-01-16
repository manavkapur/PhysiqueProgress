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
    
    private let coverageClassifier = BodyCoverageClassifier()

    private let upperBodyAnalyzer = UpperBodySilhouetteAnalyzer()
    private let upperBodyCalculator = UpperBodyShapeCalculator()
    private let upperBodyScorer = UpperBodyScorer()

    // MARK: - Public

    func analyze(
        image: UIImage,
        completion: @escaping (MLAnalysisResult?) -> Void
    ) {

        let stableImage = normalizedImage(image)
        var results: [MLAnalysisResult] = []

        func runPass(_ index: Int) {
            singleAnalyze(image: stableImage) { result in
                guard let result else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }

                results.append(result)

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
        completion: @escaping (MLAnalysisResult?) -> Void
    ) {

        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        // STEP 1 — Pose (can be nil)
        detector.detectPose(in: image) { [weak self] observation in
            guard let self else { completion(nil); return }

            // STEP 2 — Segmentation
            self.segmentationManager.generateMask(from: cgImage) { [weak self] mask in
                guard let self else { completion(nil); return }

                let hasMask = (mask != nil)

                let coverage = self.coverageClassifier.classify(
                    observation,
                    hasBodyMask: hasMask
                )

                print("🧠 BODY COVERAGE DETECTED:", coverage)

                switch coverage {

                case .full:
                    guard
                        let mask,
                        let observation
                    else {
                        completion(nil)
                        return
                    }

                    self.runFullBodyPipeline(
                        image: image,
                        mask: mask,
                        observation: observation,
                        completion: completion
                    )

                case .upper:
                    guard
                        let mask,
                        let observation
                    else {
                        completion(nil)
                        return
                    }

                    self.runUpperBodyPipeline(
                        image: image,
                        mask: mask,
                        observation: observation,
                        completion: completion
                    )

                case .invalid:
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(
                            name: .mlBodyInvalid,
                            object: "Body not detected. Please capture a clearer image."
                        )
                    }
                    completion(nil)
                }
            }
        }
    }

    // MARK: - Full body pipeline

    private func runFullBodyPipeline(
        image: UIImage,
        mask: CGImage,
        observation: VNHumanBodyPoseObservation,
        completion: @escaping (MLAnalysisResult?) -> Void
    ) {

        guard let silhouette = silhouetteAnalyzer.analyze(mask: mask) else {
            completion(nil)
            return
        }

        let physiqueMetrics = physiqueCalculator.calculate(from: silhouette)
        let physiqueScore = physiqueScorer.score(from: physiqueMetrics)

        let poseMetrics = calculator.calculateMetrics(
            from: observation,
            physiqueScore: Double(physiqueScore)
        )

        let finalPose = PoseMetrics(
            postureScore: poseMetrics.postureScore,
            symmetryScore: poseMetrics.symmetryScore,
            physiqueScore: Double(physiqueScore),
            stabilityScore: poseMetrics.stabilityScore,
            overallScore: poseMetrics.overallScore
        )

        completion(.full(pose: finalPose, shape: physiqueMetrics))
    }

    // MARK: - Upper body pipeline

    private func runUpperBodyPipeline(
        image: UIImage,
        mask: CGImage,
        observation: VNHumanBodyPoseObservation,
        completion: @escaping (MLAnalysisResult?) -> Void
    ) {

        let upperResult = upperBodyAnalyzer.analyze(mask: mask, pose: observation)

        switch upperResult {

        case .success(let upper):

            guard let upperShape = upperBodyCalculator.calculate(from: upper) else {
                print("❌ Upper body shape invalid (waist/chest missing)")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: .mlBodyInvalid,
                        object: UpperBodyFailure.unknown
                    )
                }
                completion(nil)
                return
            }

            let upperScore = upperBodyScorer.score(from: upperShape)

            let poseMetrics = calculator.calculateMetrics(
                from: observation,
                physiqueScore: Double(upperScore)
            )

            let finalPose = PoseMetrics(
                postureScore: poseMetrics.postureScore,
                symmetryScore: poseMetrics.symmetryScore,
                physiqueScore: Double(upperScore),
                stabilityScore: poseMetrics.stabilityScore,
                overallScore: poseMetrics.overallScore
            )

            completion(.upper(pose: finalPose, upper: upperShape))


        case .failure(let reason):

            print("❌ Upper body analysis failed:", reason)

            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .mlBodyInvalid,
                    object: reason
                )
            }

            completion(nil)
        }
    }

    // MARK: - Averaging

    private func average(_ results: [MLAnalysisResult]) -> MLAnalysisResult {

        let poses = results.map { $0.pose }

        let averagedPose = PoseMetrics(
            postureScore: poses.map { $0.postureScore }.avg,
            symmetryScore: poses.map { $0.symmetryScore }.avg,
            physiqueScore: poses.map { $0.physiqueScore }.avg,
            stabilityScore: poses.map { $0.stabilityScore }.avg,
            overallScore: poses.map { $0.overallScore }.avg
        )

        guard let last = results.last else {
            fatalError("MLAnalyzer average called with empty results")
        }

        switch last {
        case .full(_, let shape):
            return .full(pose: averagedPose, shape: shape)

        case .upper(_, let upper):
            return .upper(pose: averagedPose, upper: upper)
        }
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
