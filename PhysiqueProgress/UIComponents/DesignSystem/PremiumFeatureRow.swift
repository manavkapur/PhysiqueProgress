//
//  PremiumFeatureRow.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import UIKit

final class PremiumFeatureRow: UIView {

    init(text: String) {
        super.init(frame: .zero)

        let icon = UIImageView(image: UIImage(systemName: "checkmark.seal.fill"))
        icon.tintColor = .systemYellow

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.spacing = 12
        stack.alignment = .center

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}
