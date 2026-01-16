//
//  InsightCardView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class InsightCardView: UIView {

    private let container = UIView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let iconView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 20
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.06
        container.layer.shadowRadius = 10
        container.layer.shadowOffset = .init(width: 0, height: 5)

        iconView.image = UIImage(systemName: "brain.head.profile")
        iconView.tintColor = .systemPurple
        iconView.contentMode = .scaleAspectFit

        titleLabel.text = "AI Insight"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)

        bodyLabel.font = .systemFont(ofSize: 15, weight: .regular)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 0

        addSubview(container)

        [iconView, titleLabel, bodyLabel].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        container.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {

        NSLayoutConstraint.activate([

            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),

            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),

            bodyLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 12),
            bodyLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -18)
        ])
    }

    // MARK: - Public

    func set(text: String) {
        bodyLabel.text = text
    }
}
