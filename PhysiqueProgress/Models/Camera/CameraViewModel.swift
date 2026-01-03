//
//  CameraViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import UIKit

final class CameraViewModel {

    private let photoService = PhotoCaptureService()

    var onImageSaved: (() -> Void)?
    var onError: ((String) -> Void)?

    func openCamera(from viewController: UIViewController) {
        photoService.openCamera(from: viewController) { [weak self] image in
            self?.saveImage(image)
        }
    }

    private func saveImage(_ image: UIImage) {
        let fileName = "progress_\(Date().timeIntervalSince1970).jpg"

        if LocalFileManager.shared.saveImage(image, fileName: fileName) != nil {
            onImageSaved?()
        } else {
            onError?("Failed to save image")
        }
    }
}

