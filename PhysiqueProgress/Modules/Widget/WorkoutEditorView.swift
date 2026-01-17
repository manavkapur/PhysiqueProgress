//
//  WorkoutEditorView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import UIKit

final class WorkoutEditorView: UIView {

    private var fields: [Int: UITextField] = [:]

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { fatalError() }

    func load() {
        let existing = UserPlanStore.loadWorkout()?.days
                    ?? WorkoutPlanner.defaultEditablePlan()


        for (day, field) in fields {
            field.text = existing[day]
        }
    }

    func exportPlan() -> UserWorkoutPlan {
        var map: [Int: String] = [:]
        for (day, field) in fields {
            map[day] = field.text ?? ""
        }
        return UserWorkoutPlan(days: map)
    }

    private func build() {
        let title = UILabel()
        title.text = "🏋️ Weekly Workout"
        title.font = .systemFont(ofSize: 20, weight: .bold)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10

        addSubview(title)
        addSubview(stack)

        title.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        for day in 1...7 {
            let tf = UITextField()
            tf.borderStyle = .roundedRect
            tf.placeholder = "Day \(day) workout"
            fields[day] = tf
            stack.addArrangedSubview(tf)
        }
    }
}
