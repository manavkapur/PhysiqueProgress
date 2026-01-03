//
//  MLAnalyzer.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import UIKit

final class MLAnalyzer {

    private let poseDetector = PoseDetector()
    private let calculator = ProgressCalculator()

    func analyze(
        image: UIImage,
        completion: @escaping (PoseMetrics?) -> Void
    ) {
        poseDetector.detectPose(in: image) { observation in
            guard let observation else {
                completion(nil)
                return
            }

            let metrics = self.calculator.calculateMetrics(from: observation)
            completion(metrics)
        }
    }
}

