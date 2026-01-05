//
//  SubscriptionViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//
import UIKit
import StoreKit

final class SubscriptionViewController: UIViewController {

    private let viewModel = SubscriptionViewModel()

    private let subscribeButton = UIButton(type: .system)
    private let restoreButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Go Premium"
        view.backgroundColor = .systemBackground
        setupUI()
        bind()
        viewModel.loadProducts()
    }

    private func setupUI() {
        subscribeButton.setTitle("Subscribe (Monthly)", for: .normal)
        restoreButton.setTitle("Restore Purchase", for: .normal)

        subscribeButton.addTarget(
            self,
            action: #selector(subscribeTapped),
            for: .touchUpInside
        )

        restoreButton.addTarget(
            self,
            action: #selector(restoreTapped),
            for: .touchUpInside
        )

        let stack = UIStackView(arrangedSubviews: [
            subscribeButton,
            restoreButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bind() {
        viewModel.onPurchaseSuccess = { [weak self] in
            self?.showSuccess()
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }
    }

    @objc private func subscribeTapped() {
        viewModel.purchase()
    }

    @objc private func restoreTapped() {
        viewModel.restore()
    }

    private func showSuccess() {
        let alert = UIAlertController(
            title: "Success",
            message: "Premium unlocked",
            preferredStyle: .alert
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
