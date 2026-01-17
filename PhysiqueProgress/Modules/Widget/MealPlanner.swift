//
//  MealPlanner.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//

import Foundation

struct MealPlan {
    let slot: String
    let title: String
    let foods: [String]
}

enum MealPlanner {

    static func meal(for hour: Int) -> MealPlan {

        switch hour {
        case 5..<11:
            return .init(slot: "Breakfast", title: "High-protein breakfast", foods: ["Oats", "Milk", "Fruit"])
        case 11..<15:
            return .init(slot: "Lunch", title: "Balanced lunch", foods: ["Rice", "Dal", "Paneer"])
        case 15..<18:
            return .init(slot: "Snack", title: "Light snack", foods: ["Whey", "Nuts"])
        default:
            return .init(slot: "Dinner", title: "Recovery dinner", foods: ["Roti", "Veg", "Curd"])
        }
    }
}
