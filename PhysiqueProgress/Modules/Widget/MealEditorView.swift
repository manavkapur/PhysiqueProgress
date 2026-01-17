//
//  MealEditorView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import UIKit

final class MealEditorView: UIView {

    private let breakfast = makeTextView("e.g. Oats, eggs, fruit")
    private let lunch = makeTextView("e.g. Dal, rice, salad")
    private let snack = makeTextView("e.g. Nuts, yogurt, smoothie")
    private let dinner = makeTextView("e.g. Paneer, roti, vegetables")

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { fatalError() }

    func load() {

        if let m = UserPlanStore.loadMeals() {
            breakfast.text = m.breakfast.joined(separator: "\n")
            lunch.text = m.lunch.joined(separator: "\n")
            snack.text = m.snack.joined(separator: "\n")
            dinner.text = m.dinner.joined(separator: "\n")
            return
        }

        // ✅ DEFAULT FROM MEAL PLANNER
        breakfast.text = MealPlanner.meal(for: 8).foods.joined(separator: "\n")
        lunch.text = MealPlanner.meal(for: 13).foods.joined(separator: "\n")
        snack.text = MealPlanner.meal(for: 16).foods.joined(separator: "\n")
        dinner.text = MealPlanner.meal(for: 20).foods.joined(separator: "\n")
    }

    func exportPlan() -> UserMealPlan {
        func split(_ v: UITextView) -> [String] {
            v.text.split(separator: "\n").map { String($0) }
        }

        return UserMealPlan(
            breakfast: split(breakfast),
            lunch: split(lunch),
            snack: split(snack),
            dinner: split(dinner)
        )
    }

    private func build() {
        let title = UILabel()
        title.text = "🍽 Daily Meals"
        title.font = .systemFont(ofSize: 22, weight: .bold)

        let stack = UIStackView(arrangedSubviews: [
            block("Breakfast", breakfast),
            block("Lunch", lunch),
            block("Snack", snack),
            block("Dinner", dinner)
        ])

        stack.axis = .vertical
        stack.spacing = 16

        addSubview(title)
        addSubview(stack)

        title.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),

            stack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func block(_ title: String, _ tv: UITextView) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel

        tv.heightAnchor.constraint(equalToConstant: 90).isActive = true

        let stack = UIStackView(arrangedSubviews: [label, tv])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }

    private static func makeTextView(_ placeholder: String) -> UITextView {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.layer.cornerRadius = 14
        tv.backgroundColor = .secondarySystemBackground
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        tv.isScrollEnabled = true
        tv.autocorrectionType = .yes
        tv.keyboardDismissMode = .interactive
        tv.text = placeholder
        tv.textColor = .tertiaryLabel

        // placeholder behavior
        tv.delegate = TextViewPlaceholderDelegate.shared

        return tv
    }
}
