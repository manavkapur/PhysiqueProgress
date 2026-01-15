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

    private let heroView = PremiumHeroView()
    private let premiumCard = PremiumUpgradeCard()
    private let trialButton = PremiumCTAButton(title: "Subscribe")
    private let restoreButton = UIButton(type: .system)
    private let disclaimerLabel = UILabel()

    private let termsButton = UIButton(type: .system)
    private let privacyButton = UIButton(type: .system)
    
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

        disclaimerLabel.text = "Payment will be charged to your Apple ID. Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. Manage in App Store settings."
        disclaimerLabel.textColor = .secondaryLabel
        disclaimerLabel.font = .systemFont(ofSize: 12)
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.numberOfLines = 0
        
        termsButton.setTitle("Terms of Use", for: .normal)
        privacyButton.setTitle("Privacy Policy", for: .normal)

        termsButton.titleLabel?.font = .systemFont(ofSize: 12)
        privacyButton.titleLabel?.font = .systemFont(ofSize: 12)

        termsButton.setTitleColor(.secondaryLabel, for: .normal)
        privacyButton.setTitleColor(.secondaryLabel, for: .normal)

        termsButton.addTarget(self, action: #selector(openTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(openPrivacy), for: .touchUpInside)

        
        let legalStack = UIStackView(arrangedSubviews: [termsButton, privacyButton])
        legalStack.distribution = .equalSpacing
        legalStack.translatesAutoresizingMaskIntoConstraints = false
        legalStack.axis = .horizontal
        legalStack.spacing = 16
        legalStack.alignment = .center

        trialButton.addTarget(self, action: #selector(subscribeTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)

        trialButton.addTarget(self, action: #selector(pressDown), for: .touchDown)
        trialButton.addTarget(self, action: #selector(pressUp), for: [.touchUpInside, .touchCancel])

        let stack = UIStackView(arrangedSubviews: [
            heroView,
            premiumCard,
            trialButton,
            restoreButton,
            disclaimerLabel,
            legalStack
        ])

        stack.axis = .vertical
        stack.spacing = 26
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setCustomSpacing(12, after: disclaimerLabel)

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

        viewModel.onProductsLoaded = { [weak self] in
            guard let product = self?.viewModel.products.first else { return }

            let priceText = "\(product.displayPrice) / month"

            self?.premiumCard.setPrice(priceText)
            self?.trialButton.setTitle("Subscribe for \(priceText)", for: .normal)
        }


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

    @objc private func pressDown() {
        UIView.animate(withDuration: 0.12) {
            self.trialButton.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }

    @objc private func pressUp() {
        UIView.animate(withDuration: 0.12) {
            self.trialButton.transform = .identity
        }
    }

    private func showSuccess() {
        let alert = UIAlertController(
            title: "Premium Unlocked 💪",
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
    
    @objc private func openTerms() {
        openURL("https://manavkapur.github.io/physiqueprogress-legal/terms")
    }

    @objc private func openPrivacy() {
        openURL("https://manavkapur.github.io/physiqueprogress-legal/privacy")
    }

    private func openURL(_ string: String) {
        if let url = URL(string: string) {
            UIApplication.shared.open(url)
        }
    }

}
