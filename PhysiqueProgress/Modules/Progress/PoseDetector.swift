//
//  PoseDetector.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//
import Vision
import UIKit
import FirebaseCrashlytics

final class PoseDetector {

    func detectPose(
        in image: UIImage,
        completion: @escaping (VNHumanBodyPoseObservation?) -> Void
    ) {
        guard let cgImage = image.cgImage else {
            let err = NSError(domain: "ImageError", code: 1001, userInfo: [
                NSLocalizedDescriptionKey: "cgImage was nil"
            ])
            Crashlytics.crashlytics().record(error: err)
            completion(nil)
            return
        }

        let request = VNDetectHumanBodyPoseRequest()

        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: cgImagePropertyOrientation(from: image.imageOrientation),
            options: [:]
        )

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])

                let observation = request.results?.first
                completion(observation)

            } catch {
                print("❌ Vision error:", error)
                completion(nil)
            }
        }
    }
    
    func cgImagePropertyOrientation(
        from orientation: UIImage.Orientation
    ) -> CGImagePropertyOrientation {
        switch orientation {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }

}
