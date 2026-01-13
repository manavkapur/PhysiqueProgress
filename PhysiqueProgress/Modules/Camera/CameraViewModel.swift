//
//  CameraViewModel.swift
//  PhysiqueProgress
//

import UIKit

final class CameraViewModel {

    private let photoService = PhotoCaptureService()
    private let mlAnalyzer = MLAnalyzer()
    private let progressRepo = ProgressRepository()
    
    var onError: ((String) -> Void)?
    var onMLResult: ((PoseMetrics) -> Void)?

    func openCamera(from viewController: UIViewController) {
        photoService.openCamera(from: viewController) { [weak self] image in
            self?.saveImage(image)
        }
    }

    private func saveImage(_ image: UIImage) {
        let fileName = "progress_\(Date().timeIntervalSince1970).jpg"

        guard LocalFileManager.shared.saveImage(image, fileName: fileName) != nil else {
            DispatchQueue.main.async {
                self.onError?("Failed to save image")
            }
            return
        }

        mlAnalyzer.analyze(image: image){ [weak self] result in
            guard let self, let result else { return }

            let pose = result.pose
            let shape = result.shape
            let week = Calendar.current.component(.weekOfYear, from: Date())

            let entry = ProgressEntry(
                id: UUID().uuidString,
                imageFileName: fileName,
                date: Date(),

                height: 0,
                weight: nil,
                poseQuality: (pose.postureScore + pose.stabilityScore) / 2,

                overallScore: pose.overallScore,
                physiqueScore: pose.physiqueScore,

                postureScore: pose.postureScore,
                symmetryScore: pose.symmetryScore,
                stabilityScore: pose.stabilityScore,

                vTaper: Double(shape.vTaper),
                waistHip: Double(shape.waistHip),
                fatIndex: Double(shape.fatIndex),
                torsoRatio: Double(shape.torsoRatio),
                shoulderThigh: Double(shape.shoulderThigh),

                weekOfYear: week,
                engineVersion: PhysiqueEngine.version
            )

            DispatchQueue.main.async {
                self.progressRepo.save(entry)
                self.onMLResult?(pose)
            }
        }
    }
}

enum PhysiqueEngine {
    static let version = "1.0.0"
}

