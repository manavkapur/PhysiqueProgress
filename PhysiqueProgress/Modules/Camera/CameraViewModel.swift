//
//  CameraViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import UIKit
import Foundation

final class CameraViewModel {

    private let photoService = PhotoCaptureService()
    private let mlAnalyzer = MLAnalyzer()
    private let progressRepo = ProgressRepository()
    var onProcessingStarted: (() -> Void)?

    var onPremiumRequired: (() -> Void)?

    // MARK: - Outputs

    var onError: ((String) -> Void)?
    var onMLResult: ((PoseMetrics) -> Void)?
    
    // 🔥 NEW — Result screen trigger
    var onResultReady: ((ProgressEntry, ProgressEntry?) -> Void)?

    // MARK: - Camera

    func openCamera(from viewController: UIViewController) {
        checkAccessBeforeCapture {
            self.photoService.openCamera(from: viewController) { [weak self] image in
                self?.saveImage(image)
            }
        }
    }

    func openGallery(from viewController: UIViewController) {
        checkAccessBeforeCapture {
            self.photoService.openGallery(from: viewController) { [weak self] image in
                self?.saveImage(image)
            }
        }
    }


    // MARK: - Save + Analyze

    private func saveImage(_ image: UIImage) {
        
        DispatchQueue.main.async {
            self.onProcessingStarted?()   // ✅ START LOADER HERE
        }
        
        let fileName = "progress_\(Date().timeIntervalSince1970).jpg"

        guard LocalFileManager.shared.saveImage(image, fileName: fileName) != nil else {
            DispatchQueue.main.async {
                self.onError?("Failed to save image")
            }
            return
        }

        mlAnalyzer.analyze(image: image) { [weak self] result in
            guard let self, let result else { return }

            switch result {

            // MARK: - FULL BODY PIPELINE

            case .full(let pose, let shape):

                let week = Calendar.current.component(.weekOfYear, from: Date())

                let entry = ProgressEntry(
                    id: UUID().uuidString,
                    imageFileName: fileName,
                    date: Date(),
                    coverage: .full,

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
                    let last = self.progressRepo.loadAll().last   // ⚠️ before save
                    self.progressRepo.save(entry)

                    self.onMLResult?(pose)
                    self.onResultReady?(entry, last)
                }

            // MARK: - UPPER BODY PIPELINE

            case .upper(let pose, let upper):

                let week = Calendar.current.component(.weekOfYear, from: Date())

                let entry = ProgressEntry(
                    id: UUID().uuidString,
                    imageFileName: fileName,
                    date: Date(),
                    coverage: .upper,

                    height: 0,
                    weight: nil,
                    poseQuality: (pose.postureScore + pose.stabilityScore) / 2,

                    overallScore: pose.overallScore,
                    physiqueScore: pose.physiqueScore,

                    postureScore: pose.postureScore,
                    symmetryScore: pose.symmetryScore,
                    stabilityScore: pose.stabilityScore,

                    // 🔥 mapped upper → physique slots
                    vTaper: Double(upper.chestWaist),
                    waistHip: 0,
                    fatIndex: 0,
                    torsoRatio: Double(upper.torsoDominance),
                    shoulderThigh: Double(upper.shoulderChest),

                    weekOfYear: week,
                    engineVersion: PhysiqueEngine.version
                )

                DispatchQueue.main.async {
                    let last = self.progressRepo.loadAll().last
                    self.progressRepo.save(entry)

                    self.onMLResult?(pose)
                    self.onResultReady?(entry, last)
                }
            }
        }
    }
    private func todayPhotoCount() -> Int {
        let all = progressRepo.loadAll()
        let today = Calendar.current

        return all.filter {
            today.isDateInToday($0.date)
        }.count
    }
    
    private func checkAccessBeforeCapture(
        action: @escaping () -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }

            let isPremium = await SubscriptionManager.shared.hasPremiumAccess()
            let countToday = todayPhotoCount()

            let allowed = PremiumGate.canAddNewPhoto(
                isPremium: isPremium,
                todayPhotoCount: countToday
            )

            await MainActor.run {
                if allowed {
                    action()
                } else {
                    self.onPremiumRequired?()
                }
            }
        }
    }




}

// MARK: - Engine

enum PhysiqueEngine {
    static let version = "1.0.0"
}

extension Notification.Name {
    static let mlUpperBodyDetected = Notification.Name("mlUpperBodyDetected")
}
