//
//  Untitled.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import UIKit

final class CardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false 
        setup()
    }

    private func setup() {
        backgroundColor = AppColors.card
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
}
