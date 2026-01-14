//
//  Untitled.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//
import UIKit

final class CardView: UIView {

    private let container = UIView()

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
        layer.cornerRadius = 22
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 20
        layer.shadowOffset = .zero

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22)
        ])
    }

    func embed(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
}
