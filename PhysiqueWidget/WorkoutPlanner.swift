//
//  WorkoutPlanner.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 17/01/26.
//
import Foundation

struct WorkoutPlan {
    let title: String
    let focus: String
    let exercises: [String]
}

enum WorkoutPlanner {

    static func workout(for day: String) -> WorkoutPlan {
        switch day {
        case "Monday":
            return .init(title: "Push Day", focus: "Chest • Shoulders • Triceps", exercises: ["Bench Press", "Shoulder Press"])
        case "Tuesday":
            return .init(title: "Pull Day", focus: "Back • Biceps", exercises: ["Pull ups", "Rows"])
        case "Wednesday":
            return .init(title: "Leg Day", focus: "Quads • Hamstrings • Glutes", exercises: ["Squats", "RDL"])
        case "Thursday":
            return .init(title: "Core + Cardio", focus: "Abs • Endurance", exercises: ["Planks", "Cycling"])
        case "Friday":
            return .init(title: "Upper Body", focus: "Chest • Back • Arms", exercises: ["Incline press", "Lat pulldown"])
        case "Saturday":
            return .init(title: "Conditioning", focus: "Athletic • HIIT", exercises: ["Sprints", "Kettlebell"])
        default:
            return .init(title: "Recovery", focus: "Mobility • Stretching", exercises: ["Stretching", "Walking"])
        }
    }

    // ✅ ADD THIS
    static func defaultPlan() -> [String: WorkoutPlan] {
        let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]

        return Dictionary(uniqueKeysWithValues:
            days.map { day in
                (day, workout(for: day))
            }
        )
    }
    


        static func defaultEditablePlan() -> [Int: String] {
            return [
                1: "Push Day - Chest, Shoulders, Triceps",
                2: "Pull Day - Back, Biceps",
                3: "Leg Day - Quads, Hamstrings, Glutes",
                4: "Core + Cardio",
                5: "Upper Body",
                6: "Conditioning / HIIT",
                7: "Recovery / Mobility"
            ]
        }
    

    
}

