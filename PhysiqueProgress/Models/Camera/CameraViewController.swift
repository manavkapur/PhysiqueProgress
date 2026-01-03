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
        title = "Track Progress"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
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


    
}
