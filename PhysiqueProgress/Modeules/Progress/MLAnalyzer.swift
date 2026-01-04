//
//  MLAnalyzer.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import UIKit

final class MLAnalyzer {

    private let detector = PoseDetector()
    private let calculator = ProgressCalculator()

    func analyze(
        image: UIImage,
        completion: @escaping (PoseMetrics?) -> Void
    ) {
        detector.detectPose(in: image) { observation in
            guard let observation else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let metrics = self.calculator.calculateMetrics(from: observation)

            DispatchQueue.main.async {
                completion(metrics)
            }
        }
    }
}


