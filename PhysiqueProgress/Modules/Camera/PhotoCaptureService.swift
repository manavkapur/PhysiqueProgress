import UIKit

final class PhotoCaptureService: NSObject {

    private weak var presentingVC: UIViewController?
    private var completion: ((UIImage) -> Void)?

    func openImagePicker(
        from viewController: UIViewController,
        completion: @escaping (UIImage) -> Void
    ) {
        self.presentingVC = viewController
        self.completion = completion

        let sheet = UIAlertController(
            title: "Add progress photo",
            message: "Choose how you want to add your photo",
            preferredStyle: .actionSheet
        )

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "📷 Take Photo", style: .default) { _ in
                self.presentPicker(type: .camera)
            })
        }

        sheet.addAction(UIAlertAction(title: " Choose from Gallery", style: .default) { _ in
            self.presentPicker(type: .photoLibrary)
        })

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        viewController.present(sheet, animated: true)
    }

    private func presentPicker(type: UIImagePickerController.SourceType) {
        guard let vc = presentingVC else { return }

        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        picker.allowsEditing = false

        vc.present(picker, animated: true)
    }
}

// MARK: - UIImagePicker Delegate

extension PhotoCaptureService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            completion?(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
