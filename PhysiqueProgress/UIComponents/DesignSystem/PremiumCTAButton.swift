//
//  PremiumCTAButton.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import UIKit

final class PremiumCTAButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        backgroundColor = .systemYellow
        setTitleColor(.black, for: .normal)

        titleLabel?.font = .systemFont(ofSize: 19, weight: .bold)
        layer.cornerRadius = 22

        layer.shadowColor = UIColor.systemYellow.cgColor
        layer.shadowRadius = 25
        layer.shadowOpacity = 0.9
        layer.shadowOffset = .zero

        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    required init?(coder: NSCoder) { fatalError() }
}
