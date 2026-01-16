//
//  CameraViewController.swift
//  PhysiqueProgress
//

import UIKit

import FirebaseAnalytics


final class CameraViewController: UIViewController {
    
    private let viewModel = CameraViewModel()
    private let captureButton = PremiumButton(title: "Capture Photo", action: #selector(captureTapped))

    
    private let featureCard = FeatureCardView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("test_event", parameters: [
            "source": "camera",
            "time": Date().timeIntervalSince1970
        ])
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpperBody),
            name: .mlUpperBodyDetected,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInvalidBody),
            name: .mlBodyInvalid,
            object: nil
        )


        title = "Track Progress"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    private func setupUI() {
        featureCard.configure(
            icon: "camera.fill",
            title: "Capture Progress Photos",
            subtitle: "Track your physique progress with consistent photos.",
            image: UIImage(named: "pose_sample") // optional asset
        )

        captureButton.addTarget(self, action: #selector(captureTapped), for: .touchUpInside)

        view.addSubview(featureCard)
        view.addSubview(captureButton)

        NSLayoutConstraint.activate([
            featureCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            featureCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            featureCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            captureButton.topAnchor.constraint(equalTo: featureCard.bottomAnchor, constant: 30),
            captureButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            captureButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }

        viewModel.onMLResult = { pose in
            print("ML RESULT CALLBACK RECEIVED")
//            self?.showML(pose)
        }
        
        viewModel.onResultReady = { [weak self] entry, last in
            guard let self else { return }

            let vm = ResultViewModel(entry: entry, lastEntry: last)
            let vc = ResultViewController(viewModel: vm)

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func captureTapped() {
        let sheet = EnterpriseActionSheet()
        sheet.modalPresentationStyle = .overFullScreen
        sheet.modalTransitionStyle = .crossDissolve

        sheet.onCamera = { [weak self] in
            guard let self = self else { return }
            self.viewModel.openCamera(from: self)
        }

        sheet.onGallery = { [weak self] in
            guard let self = self else { return }
            self.viewModel.openGallery(from: self)
        }

        present(sheet, animated: true)
    }


    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showML(_ m: PoseMetrics) {
        let message = """
        Posture: \(Int(m.postureScore))
        Symmetry: \(Int(m.symmetryScore))
        Physique: \(Int(m.physiqueScore))
        Stability: \(Int(m.stabilityScore))

        Overall Score: \(Int(m.overallScore))
        """

        let alert = UIAlertController(
            title: "Physique Analysis",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func handleMLBodyError(_ note: Notification) {
        let message = note.object as? String ?? "Full body not visible."
        showAlert(message)
    }
    
    @objc private func handleUpperBody(_ note: Notification) {
        showAlert("Upper-body scan detected.\nFull physique analysis requires a full-body photo.")
    }

    @objc private func handleInvalidBody(_ note: Notification) {

        let reason = note.object as? UpperBodyFailure ?? .unknown

        let message: String

        switch reason {
        case .shoulderTooSmall:
            message = "Move closer to the camera and keep shoulders fully visible."

        case .chestTooSmall:
            message = "Improve lighting and face the camera straight."

        case .waistTooSmall:
            message = "Stand farther from the camera so waist is visible."

        case .segmentationWeak:
            message = "Background too bright. Try darker background."

        case .unknown:
            message = "Body not detected clearly. Please retake the photo."
        }

        showAlert(message) // or alert / banner
    }


}

extension Notification.Name {
    static let mlBodyInvalid = Notification.Name("mlBodyInvalid")
}

