//
//  MetricCardView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class MetricCardView: UIView {

    private let container = UIView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let unitLabel = UILabel()

    init(title: String, unit: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        unitLabel.text = unit
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 18
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.05
        container.layer.shadowRadius = 8
        container.layer.shadowOffset = .init(width: 0, height: 4)

        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .secondaryLabel

        valueLabel.font = .systemFont(ofSize: 28, weight: .bold)

        unitLabel.font = .systemFont(ofSize: 13, weight: .medium)
        unitLabel.textColor = .secondaryLabel

        addSubview(container)

        [titleLabel, valueLabel, unitLabel].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        container.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        
        heightAnchor.constraint(equalToConstant: 90).isActive = true
        NSLayoutConstraint.activate([

            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),

            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            unitLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            unitLabel.leadingAnchor.constraint(equalTo: valueLabel.leadingAnchor)
        ])
    }

    // MARK: - Public

    func set(value: Double) {
        valueLabel.text = String(format: "%.2f", value)
    }
}
