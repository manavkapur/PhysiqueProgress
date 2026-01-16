//
//  PhysiqueGrade.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

enum PhysiqueGrade: String {
    case obese = "Obese"
    case average = "Average"
    case fit = "Fit"
    case athletic = "Athletic"
    case elite = "Elite"
}

struct PhysiqueGrader {

    static func grade(from score: Double) -> PhysiqueGrade {
        switch score {
        case 0..<30: return .obese
        case 30..<50: return .average
        case 50..<70: return .fit
        case 70..<85: return .athletic
        default: return .elite
        }
    }
}
