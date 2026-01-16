//
//  ProgressHeroRingView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class ProgressHeroRingView: UIView {

    private let scoreLabel = UILabel()
    private let gradeLabel = UILabel()
    private let deltaLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 22
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        let stack = UIStackView(arrangedSubviews: [scoreLabel, gradeLabel, deltaLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center

        scoreLabel.font = .systemFont(ofSize: 54, weight: .bold)
        gradeLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        deltaLabel.font = .systemFont(ofSize: 16, weight: .medium)

        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 150),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(score: Int, grade: String, delta: Double) {
        scoreLabel.text = "\(score)"
        gradeLabel.text = grade

        let symbol = delta >= 0 ? "▲" : "▼"
        deltaLabel.text = "\(symbol) \(String(format: "%.1f", abs(delta))) last 30 days"
        deltaLabel.textColor = delta >= 0 ? .systemGreen : .systemRed
    }
}
