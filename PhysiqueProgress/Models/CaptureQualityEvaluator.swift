//
//  CaptureQualityEvaluator.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

//
//  CaptureQualityEvaluator.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import Vision
import UIKit

struct CaptureQualityResult {
    let score: Double          // 0 – 100
    let poseConfidence: Double // 0 – 1
    let maskStrength: Double   // 0 – 1
    let bodyFill: Double       // 0 – 1
}

final class CaptureQualityEvaluator {

    // MARK: - Public entry

    func evaluate(
        observation: VNHumanBodyPoseObservation?,
        mask: CGImage?
    ) -> CaptureQualityResult {

        let poseConf = poseConfidence(from: observation)
        let maskConf = maskStrength(from: mask)
        let bodyFill = bodyFillRatio(from: mask)

        // 🔥 weighted fusion
        let final =
              0.45 * poseConf
            + 0.35 * maskConf
            + 0.20 * bodyFill

        return CaptureQualityResult(
            score: final * 100,
            poseConfidence: poseConf,
            maskStrength: maskConf,
            bodyFill: bodyFill
        )
    }

    // MARK: - Pose confidence

    private func poseConfidence(
        from obs: VNHumanBodyPoseObservation?
    ) -> Double {

        guard
            let obs,
            let points = try? obs.recognizedPoints(.all),
            !points.isEmpty
        else { return 0 }

        let valid = points.values.filter { $0.confidence > 0.2 }

        guard !valid.isEmpty else { return 0 }

        let avg = valid.map { Double($0.confidence) }.reduce(0, +) / Double(valid.count)

        // reward having many joints
        let coverageBonus = min(Double(valid.count) / 18.0, 1.0)

        return min((avg * 0.75) + (coverageBonus * 0.25), 1.0)
    }

    // MARK: - Mask strength

    private func maskStrength(from mask: CGImage?) -> Double {
        guard let mask,
              let data = mask.dataProvider?.data,
              let ptr = CFDataGetBytePtr(data)
        else { return 0 }

        let width = mask.width
        let height = mask.height
        let bytesPerRow = mask.bytesPerRow
        let bytesPerPixel = 4

        var strongPixels = 0
        var total = 0

        for y in stride(from: 0, to: height, by: 3) {
            let row = ptr + y * bytesPerRow
            for x in stride(from: 0, to: width, by: 3) {
                let offset = x * bytesPerPixel
                let v = Int(row[offset]) +
                        Int(row[offset + 1]) +
                        Int(row[offset + 2])

                if v > 100 { strongPixels += 1 }
                total += 1
            }
        }

        guard total > 0 else { return 0 }
        return min(Double(strongPixels) / Double(total), 1.0)
    }

    // MARK: - Body fill ratio

    private func bodyFillRatio(from mask: CGImage?) -> Double {
        guard let mask else { return 0 }

        let bodyArea = countBodyPixels(mask)
        let imageArea = Double(mask.width * mask.height)

        let ratio = bodyArea / imageArea

        // Ideal range: 18% – 55%
        if ratio < 0.10 { return ratio * 2 }          // too small
        if ratio > 0.65 { return max(0, 1 - ratio) }  // too zoomed

        return min(ratio / 0.45, 1.0)
    }

    private func countBodyPixels(_ mask: CGImage) -> Double {

        guard let data = mask.dataProvider?.data,
              let ptr = CFDataGetBytePtr(data)
        else { return 0 }

        let width = mask.width
        let height = mask.height
        let bytesPerRow = mask.bytesPerRow
        let bytesPerPixel = 4

        var count = 0

        for y in stride(from: 0, to: height, by: 2) {
            let row = ptr + y * bytesPerRow
            for x in stride(from: 0, to: width, by: 2) {
                let offset = x * bytesPerPixel
                let v = Int(row[offset]) +
                        Int(row[offset + 1]) +
                        Int(row[offset + 2])
                if v > 90 { count += 1 }
            }
        }

        return Double(count * 4) // compensate sampling
    }
}
