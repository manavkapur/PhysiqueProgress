//
//  FullBodyValidator.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import Vision

enum BodyValidationError: String {
    case noPersonDetected = "No person detected. Stand in frame."
    case upperBodyOnly = "Full body not visible. Step back and include feet."
    case badPose = "Stand straight, face camera, arms relaxed."
}

final class FullBodyValidator {

    func validate(_ observation: VNHumanBodyPoseObservation) -> BodyValidationError? {

        guard let points = try? observation.recognizedPoints(.all) else {
            return .noPersonDetected
        }

        // Required joints for FULL BODY
        let required: [VNHumanBodyPoseObservation.JointName] = [
            .nose,
            .leftShoulder, .rightShoulder,
            .leftHip, .rightHip,
            .leftKnee, .rightKnee,
            .leftAnkle, .rightAnkle
        ]

        for joint in required {
            if points[joint] == nil || points[joint]!.confidence < 0.3 {
                return .upperBodyOnly
            }
        }

        // Optional posture sanity
        if abs(points[.leftAnkle]!.y - points[.rightAnkle]!.y) > 0.15 {
            return .badPose
        }

        return nil // ✅ valid full body
    }
}
