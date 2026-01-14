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
        setTitle("⭐︎ " + title, for: .normal)
        addTarget(nil, action: action, for: .touchUpInside)

        backgroundColor = UIColor.systemYellow.withAlphaComponent(0.15)
        setTitleColor(.systemYellow, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        layer.cornerRadius = 14
        heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    required init?(coder: NSCoder) { fatalError() }
}
