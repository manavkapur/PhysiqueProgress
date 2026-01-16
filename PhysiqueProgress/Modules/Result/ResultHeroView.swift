//
//  ResultHeroView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class ResultHeroView: UIView {

    private let scoreLabel = UILabel()
    private let gradeLabel = UILabel()
    private let deltaLabel = UILabel()
    private let coverageLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        let stack = UIStackView(arrangedSubviews: [
            scoreLabel, gradeLabel, deltaLabel, coverageLabel
        ])

        stack.axis = .vertical
        stack.spacing = 8
        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 20

        scoreLabel.font = .systemFont(ofSize: 48, weight: .bold)
        gradeLabel.font = .systemFont(ofSize: 22, weight: .semibold)
    }

    func configure(with hero: HeroModel) {
        scoreLabel.text = "\(hero.score)"
        gradeLabel.text = hero.grade.rawValue
        deltaLabel.text = hero.delta >= 0 ? "▲ \(Int(hero.delta))" : "▼ \(Int(hero.delta))"
        coverageLabel.text = hero.coverage == .full ? "Full body scan" : "Upper body scan"
    }
}
