//
//  TodayPlanSnapshot.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import Foundation

struct TodayPlanSnapshot: Codable {

    let weekday: String

    // WORKOUT
    let workoutTitle: String
    let workoutFocus: String
    let exercises: [String]

    // MEAL
    let mealSlot: String
    let mealTitle: String
    let foods: [String]

    let updatedAt: Date
}
