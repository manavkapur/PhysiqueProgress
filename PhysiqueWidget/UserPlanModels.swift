//
//  UserPlanModels.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 18/01/26.
//


import Foundation

struct UserWorkoutPlan: Codable {
    var days: [Int: String]   // 1...7 → workout name
}

struct UserMealPlan: Codable {
    var breakfast: [String]
    var lunch: [String]
    var snack: [String]
    var dinner: [String]
}
