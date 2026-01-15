//
//  PremiumUpgradeCard.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//
import UIKit

final class PremiumUpgradeCard: UIView {

    private let title = UILabel()
    private let subtitle = UILabel()
    private let featuresStack = UIStackView()
    private let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func build() {

        backgroundColor = UIColor.white.withAlphaComponent(0.05)
        layer.cornerRadius = 28
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 30
        layer.shadowOffset = .zero

        title.text = "Upgrade to Premium"
        title.font = .systemFont(ofSize: 30, weight: .bold)
        title.textColor = .white

        subtitle.text = "Unlock your full physique potential"
        subtitle.font = .systemFont(ofSize: 15)
        subtitle.textColor = .secondaryLabel

        priceLabel.text = "$9.99/month after 7-day free trial"
        priceLabel.font = .systemFont(ofSize: 13, weight: .medium)
        priceLabel.textColor = .tertiaryLabel

        featuresStack.axis = .vertical
        featuresStack.spacing = 14

        [
            "Unlimited progress photos",
            "Advanced physique metrics",
            "Premium AI analysis",
            "Exclusive future features"
        ].forEach {
            featuresStack.addArrangedSubview(PremiumFeatureRow(text: $0))
        }

        let stack = UIStackView(arrangedSubviews: [
            title, subtitle, featuresStack, priceLabel
        ])

        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    func setPrice(_ text: String) {
        priceLabel.text = text
    }
}
