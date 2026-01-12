//
//  MLAnalyzer.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import UIKit
import Vision

final class MLAnalyzer {

    private let detector = PoseDetector()
    private let calculator = ProgressCalculator()

    // 🔥 NEW
    private let segmentationManager = BodySegmentationManager()
    private let silhouetteAnalyzer = SilhouetteAnalyzer()

    func analyze(
        image: UIImage,
        completion: @escaping (PoseMetrics?) -> Void
    ) {

        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async { completion(nil) }
            return
        }

        // 1️⃣ Run body segmentation first
        segmentationManager.generateMask(from: cgImage) { [weak self] mask in
            guard let self else { return }

            guard let mask else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            // 2️⃣ Extract silhouette metrics
            let silhouette = self.silhouetteAnalyzer.analyze(mask: mask)

            // 3️⃣ Run pose detection (your existing system)
            self.detector.detectPose(in: image) { observation in
                guard let observation else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }

                // 4️⃣ Merge pose + silhouette into final metrics
                let metrics = self.calculator.calculateMetrics(
                    from: observation,
                    silhouette: silhouette
                )

                DispatchQueue.main.async {
                    completion(metrics)
                }
            }
        }
    }
}
