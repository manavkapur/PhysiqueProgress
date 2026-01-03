//
//  PoseDetector.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import Vision
import UIKit

final class PoseDetector {
    
    func detectPose(in image: UIImage,
    completion: @escaping (VNHumanBodyPoseObservation?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        
        let request = VNDetectHumanBodyPoseRequest()
        
        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: .up,
            options: [:]
        )
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
                let observation = request.results?.first
                completion(observation)
            } catch {
                print("Pose Detection failed: \(error)")
                completion(nil)
            }
        }
    }
}
