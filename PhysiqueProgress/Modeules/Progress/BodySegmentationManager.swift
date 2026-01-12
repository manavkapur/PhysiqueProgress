//
//  BodySegmentationManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 12/01/26.
//

import Vision
import UIKit

final class BodySegmentationManager {

    func generateMask(from image: CGImage,
                      completion: @escaping (CVPixelBuffer?) -> Void) {

        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = .accurate
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8
        request.usesCPUOnly = false

        let handler = VNImageRequestHandler(cgImage: image, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
                let result = request.results?.first as? VNPixelBufferObservation
                completion(result?.pixelBuffer)
            } catch {
                print("❌ Segmentation failed:", error)
                completion(nil)
            }
        }
    }
}
