//
//  PrimaryButton.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import UIKit

final class PrimaryButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = AppColors.primary
        setTitleColor(.black, for: .normal)
        setTitleColor(.black.withAlphaComponent(0.4), for: .disabled)

        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 16

        heightAnchor.constraint(equalToConstant: 52).isActive = true

        // subtle enterprise polish
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 6)
    }

    func setLoading(_ loading: Bool) {
        isEnabled = !loading
        alpha = loading ? 0.7 : 1
    }
}
