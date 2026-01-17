//
//  PlanEditorViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import UIKit
import Foundation

extension Notification.Name {
    static let todayPlanUpdated = Notification.Name("todayPlanUpdated")
}


final class PlanEditorViewController: UIViewController {

    private let workoutView = WorkoutEditorView()
    private let mealView = MealEditorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Daily Plan"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )

        let scrollView = UIScrollView()
        let contentView = UIView()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        let stack = UIStackView(arrangedSubviews: [workoutView, mealView])
        stack.axis = .vertical
        stack.spacing = 20

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24) // 🔥 important for scrolling
        ])

        workoutView.load()
        mealView.load()

        setupKeyboardDismiss()
    }


    @objc private func saveTapped() {

        UserPlanStore.saveWorkout(workoutView.exportPlan())
        UserPlanStore.saveMeals(mealView.exportPlan())

        WidgetRefreshManager.refreshTodayWidget()
        
        // ✅ Notify app (card + any listeners)
        NotificationCenter.default.post(name: .todayPlanUpdated, object: nil)

        let alert = UIAlertController(title: "Saved", message: "Plan updated & widget refreshed.", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
        
       

    }
    
    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}
