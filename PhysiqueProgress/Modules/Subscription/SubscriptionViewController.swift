//
//  SubscriptionViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//
//  SubscriptionViewController.swift
//  PhysiqueProgress
//

import UIKit
import StoreKit

final class SubscriptionViewController: UIViewController {

    private let viewModel = SubscriptionViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let premiumCard = PremiumUpgradeCard()
    private let trialButton = PremiumCTAButton(title: "Start Your Free Trial")
    private let restoreButton = UIButton(type: .system)
    private let disclaimerLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Go Premium"
        view.backgroundColor = AppColors.background

        setupUI()
        bind()
        viewModel.loadProducts()
    }

    private func setupUI() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        restoreButton.setTitle("Restore Purchase", for: .normal)
        restoreButton.setTitleColor(.systemBlue, for: .normal)
        restoreButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)

        disclaimerLabel.text = "Cancel anytime. No charge if cancelled during trial."
        disclaimerLabel.textColor = .secondaryLabel
        disclaimerLabel.font = .systemFont(ofSize: 12)
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.numberOfLines = 0

        trialButton.addTarget(self, action: #selector(subscribeTapped), for: .touchUpInside)
        
        trialButton.addTarget(self, action: #selector(pressDown), for: .touchDown)
        trialButton.addTarget(self, action: #selector(pressUp), for: [.touchUpInside, .touchCancel])

        
        restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        
        let heroImageView = PremiumHeroView()
        
        heroImageView.layer.shadowColor = UIColor.systemYellow.cgColor
        heroImageView.layer.shadowOpacity = 0.25
        heroImageView.layer.shadowRadius = 30
        heroImageView.layer.shadowOffset = .zero

        
        let stack = UIStackView(arrangedSubviews: [
            heroImageView,
            premiumCard,
            trialButton,
            restoreButton,
            disclaimerLabel
        ])

        stack.axis = .vertical
        stack.spacing = 26
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    private func bind() {
        viewModel.onPurchaseSuccess = { [weak self] in
            self?.showSuccess()
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }

        viewModel.onProductLoaded = { [weak self] price in
            self?.premiumCard.setPrice(price)
        }
    }

    @objc private func subscribeTapped() {
        viewModel.purchase()
    }

    @objc private func restoreTapped() {
        viewModel.restore()
    }
    
    @objc func pressDown() {
        UIView.animate(withDuration: 0.12) {
            self.trialButton.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }

    @objc func pressUp() {
        UIView.animate(withDuration: 0.12) {
            self.trialButton.transform = .identity
        }
    }

    private func showSuccess() {
        let alert = UIAlertController(
            title: "Premium Unlocked",
            message: "All premium features are now available.",
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Continue", style: .default))
        present(alert, animated: true)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Purchase Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
