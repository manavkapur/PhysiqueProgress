import UIKit

final class PhotoCaptureService: NSObject {

    private weak var presentingVC: UIViewController?
    private var completion: ((UIImage) -> Void)?

    func openCamera(
        from viewController: UIViewController,
        completion: @escaping (UIImage) -> Void
    ) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }

        self.presentingVC = viewController
        self.completion = completion

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false

        viewController.present(picker, animated: true)
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

    func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController
    ) {
        picker.dismiss(animated: true)
    }
}

