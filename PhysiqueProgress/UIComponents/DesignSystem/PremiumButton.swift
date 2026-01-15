//
//  PremiumButton.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//
import UIKit

final class PremiumButton: UIButton {

    init(title: String, action: Selector) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        setTitle("⭐︎ " + title, for: .normal)
        addTarget(nil, action: action, for: .touchUpInside)

        backgroundColor = AppColors.primary.withAlphaComponent(0.18)
        setTitleColor(AppColors.primary, for: .normal)
        setTitleColor(AppColors.primary.withAlphaComponent(0.4), for: .highlighted)

        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 16

        heightAnchor.constraint(equalToConstant: 54).isActive = true

        // Enterprise glow
        layer.shadowColor = AppColors.primary.cgColor
        layer.shadowOpacity = 0.35
        layer.shadowRadius = 14
        layer.shadowOffset = CGSize(width: 0, height: 6)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
