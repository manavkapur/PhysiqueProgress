//
//  TodayPlanCardView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import UIKit

final class TodayPlanCardView: UIView {

    private let container = UIView()
    private let titleLabel = UILabel()
    private let workoutLabel = UILabel()
    private let mealLabel = UILabel()
    private let editLabel = UILabel()


    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
        configure() // ✅ initial load
    }




    required init?(coder: NSCoder) { fatalError() }

    private func build() {

        
        container.backgroundColor = UIColor.secondarySystemBackground
        container.layer.cornerRadius = 24
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.12
        container.layer.shadowRadius = 10
        container.layer.shadowOffset = .init(width: 0, height: 6)

        titleLabel.text = "Today’s Plan"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)

        workoutLabel.font = .systemFont(ofSize: 16, weight: .medium)
        mealLabel.font = .systemFont(ofSize: 15, weight: .regular)
        mealLabel.textColor = .secondaryLabel

        editLabel.text = "Edit plan →"
        editLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        editLabel.textColor = .systemGreen

        let stack = UIStackView(arrangedSubviews: [
            titleLabel, workoutLabel, mealLabel, editLabel
        ])
        stack.axis = .vertical
        stack.spacing = 8

        addSubview(container)
        container.addSubview(stack)

        container.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),

            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20)
        ])
    }

    func configure() {
        let snapshot = TodayPlanEngine.buildTodayPlan()
        workoutLabel.text = "🏋️ \(snapshot.workoutTitle)"
        mealLabel.text = "🍽 \(snapshot.mealSlot): \(snapshot.mealTitle)"
    }


}
