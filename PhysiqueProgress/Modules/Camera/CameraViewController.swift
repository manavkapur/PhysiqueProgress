//
//  CameraViewController.swift
//  PhysiqueProgress
//

import UIKit

final class CameraViewController: UIViewController {
    
    private let viewModel = CameraViewModel()
    private let captureButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🚀 CameraViewController appeared")
        title = "Track Progress"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        #if DEBUG
        testMLWithImage(named: "posereal")
        #endif
    }

    private func setupUI() {
        captureButton.setTitle("Capture photo", for: .normal)
        captureButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        captureButton.addTarget(self, action: #selector(captureTapped), for: .touchUpInside)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(captureButton)
        
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }

        viewModel.onMLResult = { [weak self] pose in
            print("ML RESULT CALLBACK RECEIVED")
            self?.showML(pose)
        }
    }
    
    @objc private func captureTapped() {
        viewModel.openCamera(from: self)
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
    
    func testMLWithImage(named name: String) {
        guard let image = UIImage(named: name) else {
            showAlert("Test image not found")
            return
        }

        MLAnalyzer().analyze(image: image) { [weak self] result in
            guard let result else {
                self?.showAlert("No ML metrics returned")
                return
            }
            self?.showML(result.pose)
        }
    }
}
