//
//  ProgressInsightEngine.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

final class ProgressInsightEngine {

    func insight(from entries: [ProgressEntry]) -> String {

        guard entries.count >= 2 else {
            return "First scan recorded. Stay consistent."
        }

        let full = entries.filter { $0.coverage == .full }
        guard full.count >= 2 else {
            return "Upper physique scans logged. Do a full body scan for fat tracking."
        }

        let first = full.first!
        let last = full.last!

        let fatDiff = last.fatIndex - first.fatIndex
        let physiqueDiff = last.physiqueScore - first.physiqueScore

        if fatDiff < -0.05 && physiqueDiff > 4 {
            return "Excellent recomposition. Fat reduced and physique improved."
        }

        if fatDiff < -0.05 {
            return "Fat reduction detected. Good progress."
        }

        if physiqueDiff > 4 {
            return "Upper physique improving. Consider a full body scan."
        }

        return "Progress stable. Consistency is key."
    }
}
