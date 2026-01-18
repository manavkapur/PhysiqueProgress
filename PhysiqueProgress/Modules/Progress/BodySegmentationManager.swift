//
//  BodySegmentationManager.swift
//  PhysiqueProgress
//

import Vision
import UIKit
import FirebaseCrashlytics

final class BodySegmentationManager {

    private let context = CIContext()

    func generateMask(from image: CGImage,
                      completion: @escaping (CGImage?) -> Void) {

        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = .accurate
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8

        let handler = VNImageRequestHandler(cgImage: image, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])

                guard let result = request.results?.first as? VNPixelBufferObservation else {
                    completion(nil)
                    return
                }

                let ciImage = CIImage(cvPixelBuffer: result.pixelBuffer)

                guard let cgMask = self.context.createCGImage(ciImage, from: ciImage.extent) else {
                    completion(nil)
                    return
                }

                // 🧪 debug once
                #if DEBUG && false
                DispatchQueue.main.async {
                    UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: cgMask), nil, nil, nil)
                    print("✅ Mask saved")
                    print("bitsPerPixel:", cgMask.bitsPerPixel)
                    print("alphaInfo:", cgMask.alphaInfo.rawValue)
                }
                #endif

                completion(cgMask)

            } catch {
                print("❌ Segmentation failed:", error)
                Crashlytics.crashlytics().record(error: error)
                completion(nil)
            }
        }
    }
}
