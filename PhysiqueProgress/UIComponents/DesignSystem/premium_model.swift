//
//  premium_model.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import UIKit

final class PremiumHeroView: UIView {

    private let imageView = UIImageView()
    private let glow = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func build() {

        imageView.image = UIImage(named: "premium_model") // add asset
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 26

        glow.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.25)
        glow.layer.cornerRadius = 26
        glow.layer.shadowColor = UIColor.systemYellow.cgColor
        glow.layer.shadowRadius = 40
        glow.layer.shadowOpacity = 0.9
        glow.layer.shadowOffset = .zero

        addSubview(glow)
        addSubview(imageView)

        glow.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            glow.topAnchor.constraint(equalTo: topAnchor),
            glow.bottomAnchor.constraint(equalTo: bottomAnchor),
            glow.leadingAnchor.constraint(equalTo: leadingAnchor),
            glow.trailingAnchor.constraint(equalTo: trailingAnchor),

            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightAnchor.constraint(equalToConstant: 280)
        ])
    }
}

