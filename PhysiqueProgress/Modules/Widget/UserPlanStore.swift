//
//  UserPlanStore.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import Foundation

final class UserPlanStore {

    private static let suite = UserDefaults(suiteName: "group.com.apertix.physiqueprogress")!

    private static let workoutKey = "user.workout.plan"
    private static let mealKey = "user.meal.plan"

    // MARK: Workout

    static func saveWorkout(_ plan: UserWorkoutPlan) {
        if let data = try? JSONEncoder().encode(plan) {
            suite.set(data, forKey: workoutKey)
        }
    }

    static func loadWorkout() -> UserWorkoutPlan? {
        guard let data = suite.data(forKey: workoutKey) else { return nil }
        return try? JSONDecoder().decode(UserWorkoutPlan.self, from: data)
    }

    // MARK: Meals

    static func saveMeals(_ plan: UserMealPlan) {
        if let data = try? JSONEncoder().encode(plan) {
            suite.set(data, forKey: mealKey)
        }
    }

    static func loadMeals() -> UserMealPlan? {
        guard let data = suite.data(forKey: mealKey) else { return nil }
        return try? JSONDecoder().decode(UserMealPlan.self, from: data)
    }
}
