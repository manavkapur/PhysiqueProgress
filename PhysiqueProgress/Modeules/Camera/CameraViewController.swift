//
//  CameraViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import UIKit

final class CameraViewController: UIViewController {
    
    
    private let viewModel = CameraViewModel()
    
    private let captureButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🚀 CameraViewController appeared 1")
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
        viewModel.onImageSaved = { [weak self] in
            self?.showSuccess()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert( message)
        }
        
        
    }
    
    @objc private func captureTapped() {
        viewModel.openCamera(from: self)
    }
    
    private func showSuccess(){
        let alert = UIAlertController(
            title: "Saved", message: "Your progress photo was saved locally", preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        Proportion: \(Int(m.proportionScore))
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
    #if targetEnvironment(simulator)
        showML(mockMetrics())
        return
    #endif

        guard let image = UIImage(named: name) else {
            showAlert("Test image not found")
            return
        }

        MLAnalyzer().analyze(image: image) { [weak self] metrics in
            guard let metrics else {
                self?.showAlert("No ML metrics returned")
                return
            }
            self?.showML(metrics)
        }
    }


#if DEBUG
private func mockMetrics() -> PoseMetrics {
    PoseMetrics(
        postureScore: 82,
        symmetryScore: 74,
        proportionScore: 68,
        stabilityScore: 80,
        overallScore: 76
    )
}
#endif

    
}
