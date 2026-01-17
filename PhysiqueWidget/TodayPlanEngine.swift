//
//  TodayPlanEngine.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//


import Foundation

final class TodayPlanEngine {

    static func buildTodayPlan() -> TodayPlanSnapshot {

        let systemDay = Calendar.current.component(.weekday, from: Date())
        // 1 = Sunday ... 7 = Saturday

        let weekdayIndex = systemDay == 1 ? 7 : systemDay - 1
        // Monday = 1 ... Sunday = 7 ✅ matches editor

        let hour = Calendar.current.component(.hour, from: Date())

        let workoutPlan = UserPlanStore.loadWorkout()
        let mealPlan = UserPlanStore.loadMeals()

        let workoutTitle = workoutPlan?.days[weekdayIndex] ?? "Recovery"

        let mealBlock = resolveMealBlock(hour: hour, meals: mealPlan)

        return TodayPlanSnapshot(
            weekday: weekdayName(),
            workoutTitle: workoutTitle,
            workoutFocus: "",
            exercises: [],
            mealSlot: mealBlock.slot,
            mealTitle: mealBlock.title,
            foods: mealBlock.foods,
            updatedAt: Date()
        )
    }

    // ✅ REAL MEAL RESOLUTION (from editor data)
    private static func resolveMealBlock(
        hour: Int,
        meals: UserMealPlan?
    ) -> (slot: String, title: String, foods: [String]) {

        guard let meals else {
            return ("Meal", "Not set", [])
        }

        switch hour {
        case 5..<11:
            return ("Breakfast",
                    meals.breakfast.joined(separator: ", "),
                    meals.breakfast)

        case 11..<16:
            return ("Lunch",
                    meals.lunch.joined(separator: ", "),
                    meals.lunch)

        case 16..<19:
            return ("Snack",
                    meals.snack.joined(separator: ", "),
                    meals.snack)

        default:
            return ("Dinner",
                    meals.dinner.joined(separator: ", "),
                    meals.dinner)
        }
    }

    private static func weekdayName() -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f.string(from: Date())
    }
}
