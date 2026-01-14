//
//  Untitled.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import UIKit

final class AppTextField: UITextField {

    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        autocapitalizationType = .none
        backgroundColor = AppColors.background
        textColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = AppColors.border.cgColor
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        setLeftPadding(14)

        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: AppColors.textSecondary]
        )
    }
    override func becomeFirstResponder() -> Bool {
        layer.borderColor = AppColors.primary.cgColor
        layer.shadowColor = AppColors.primary.cgColor
        layer.shadowOpacity = 0.35
        layer.shadowRadius = 8
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        layer.borderColor = AppColors.border.cgColor
        layer.shadowOpacity = 0
        return super.resignFirstResponder()
    }

}
