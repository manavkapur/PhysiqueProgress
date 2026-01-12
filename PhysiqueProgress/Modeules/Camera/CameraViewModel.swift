//
//  CameraViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import UIKit

final class CameraViewModel {

    private let photoService = PhotoCaptureService()
    private let mlAnalyzer = MLAnalyzer()
    
    
    var onImageSaved: (() -> Void)?
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

        mlAnalyzer.analyze(image: image) { [weak self] metrics in
            guard let self, let metrics else { return }

            DispatchQueue.main.async {
                self.onMLResult?(metrics)   // ✅ only one alert now
            }
        }
    }


}

