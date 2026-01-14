//
//  DangerButton.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import UIKit

final class DangerButton: UIButton {

    init(title: String, action: Selector) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        addTarget(nil, action: action, for: .touchUpInside)

        backgroundColor = UIColor.systemRed.withAlphaComponent(0.12)
        setTitleColor(.systemRed, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        layer.cornerRadius = 14
        heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    required init?(coder: NSCoder) { fatalError() }
}
