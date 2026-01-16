//
//  ConsistencyCardView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class ConsistencyCardView: UIView {

    private let label = UILabel()

    init() {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16

        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 70),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(scansPerWeek: Double) {
        label.text = "Consistency: \(String(format: "%.1f", scansPerWeek)) scans / week"
    }
}
