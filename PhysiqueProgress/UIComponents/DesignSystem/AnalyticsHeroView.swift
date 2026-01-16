//
//  AnalyticsHeroView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//
//
//  AnalyticsHeroView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class AnalyticsHeroView: UIView {

    private let container = UIView()
    private let stack = UIStackView()

    private let scoreLabel = UILabel()
    private let gradeLabel = UILabel()
    private let deltaLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {

        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 22
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.08
        container.layer.shadowRadius = 10
        container.layer.shadowOffset = .init(width: 0, height: 6)

        scoreLabel.font = .systemFont(ofSize: 54, weight: .bold)
        scoreLabel.textAlignment = .center

        gradeLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        gradeLabel.textColor = .secondaryLabel
        gradeLabel.textAlignment = .center

        deltaLabel.font = .systemFont(ofSize: 17, weight: .medium)
        deltaLabel.textAlignment = .center

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10

        [scoreLabel, gradeLabel, deltaLabel, subtitleLabel].forEach {
            stack.addArrangedSubview($0)
        }

        addSubview(container)
        container.addSubview(stack)

        container.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Layout

    private func setupLayout() {

        NSLayoutConstraint.activate([

            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),

            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])

        // 🔥 Enterprise safety
        heightAnchor.constraint(greaterThanOrEqualToConstant: 180).isActive = true

        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .vertical)
    }

    // MARK: - Public

    func configure(score: Int,
                   grade: String,
                   delta: Double,
                   subtitle: String) {

        scoreLabel.text = "\(score)"
        gradeLabel.text = grade

        if delta == 0 {
            deltaLabel.text = "No change yet"
            deltaLabel.textColor = .secondaryLabel
        } else if delta > 0 {
            deltaLabel.text = "▲ +\(String(format: "%.1f", delta)) improving"
            deltaLabel.textColor = .systemGreen
        } else {
            deltaLabel.text = "▼ \(String(format: "%.1f", abs(delta))) dropped"
            deltaLabel.textColor = .systemRed
        }

        subtitleLabel.text = subtitle
    }
}
