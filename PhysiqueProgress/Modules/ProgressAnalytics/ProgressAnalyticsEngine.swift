//
//  ProgressAnalyticsEngine.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import Foundation

// MARK: - Time Range

enum TimeRange {
    case days7, days30, days90, all

    func includes(_ date: Date) -> Bool {
        switch self {
        case .days7:
            return date >= Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        case .days30:
            return date >= Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        case .days90:
            return date >= Calendar.current.date(byAdding: .day, value: -90, to: Date())!
        case .all:
            return true
        }
    }
}

// MARK: - Analytics Engine

final class ProgressAnalyticsEngine {

    private let allEntries: [ProgressEntry]

    init(entries: [ProgressEntry]) {
        self.allEntries = entries.sorted { $0.date < $1.date }
    }

    // MARK: - Core Filter

    func filtered(
        coverage: BodyCoverageType?,
        range: TimeRange
    ) -> [ProgressEntry] {

        allEntries.filter {
            (coverage == nil || $0.coverage == coverage) &&
            range.includes($0.date)
        }
    }

    // MARK: - Series Builders

    func physiqueSeries(coverage: BodyCoverageType?, range: TimeRange) -> [Double] {
        filtered(coverage: coverage, range: range).map { $0.physiqueScore }
    }

    func overallSeries(coverage: BodyCoverageType?, range: TimeRange) -> [Double] {
        filtered(coverage: coverage, range: range).map { $0.overallScore }
    }

    func vTaperSeries(coverage: BodyCoverageType?, range: TimeRange) -> [Double] {
        filtered(coverage: coverage, range: range).map { $0.vTaper }
    }

    func fatIndexSeries(coverage: BodyCoverageType?, range: TimeRange) -> [Double] {
        filtered(coverage: coverage, range: range).map { $0.fatIndex }
    }

    func torsoSeries(coverage: BodyCoverageType?, range: TimeRange) -> [Double] {
        filtered(coverage: coverage, range: range).map { $0.torsoRatio }
    }

    func postureSeries(coverage: BodyCoverageType?, range: TimeRange) -> [Double] {
        filtered(coverage: coverage, range: range).map { $0.postureScore }
    }

    func symmetrySeries(coverage: BodyCoverageType?, range: TimeRange) -> [Double] {
        filtered(coverage: coverage, range: range).map { $0.symmetryScore }
    }

    // MARK: - Hero

    func latest(coverage: BodyCoverageType?, range: TimeRange) -> ProgressEntry? {
        filtered(coverage: coverage, range: range).last
    }

    func deltaPhysique(coverage: BodyCoverageType?, range: TimeRange) -> Double {
        let list = filtered(coverage: coverage, range: range)
        guard list.count >= 2 else { return 0 }
        return list.last!.physiqueScore - list.first!.physiqueScore
    }

    // MARK: - Consistency

    func scansPerWeek() -> Double {
        guard let first = allEntries.first else { return 0 }
        let weeks = max(Calendar.current.dateComponents([.weekOfYear], from: first.date, to: Date()).weekOfYear ?? 1, 1)
        return Double(allEntries.count) / Double(weeks)
    }

    func bestStreakDays() -> Int {
        let dates = allEntries.map { Calendar.current.startOfDay(for: $0.date) }
        let uniqueDays = Array(Set(dates)).sorted()

        var best = 1
        var current = 1

        for i in 1..<uniqueDays.count {
            let diff = Calendar.current.dateComponents([.day], from: uniqueDays[i-1], to: uniqueDays[i]).day ?? 0
            if diff == 1 {
                current += 1
                best = max(best, current)
            } else {
                current = 1
            }
        }

        return best
    }

    // MARK: - Insight Engine

    func insight(coverage: BodyCoverageType?, range: TimeRange) -> String {
        let list = filtered(coverage: coverage, range: range)
        guard list.count >= 2 else {
            return "Not enough scans yet. Take 2–3 consistent scans to unlock full progress insights."
        }

        let first = list.first!
        let last = list.last!

        let physiqueDelta = last.physiqueScore - first.physiqueScore
        let fatDelta = last.fatIndex - first.fatIndex
        let taperDelta = last.vTaper - first.vTaper
        let postureDelta = last.postureScore - first.postureScore

        var lines: [String] = []

        // Overall trend
        if physiqueDelta > 2 {
            lines.append("Your physique is improving strongly.")
        } else if physiqueDelta > 0 {
            lines.append("Your physique is improving gradually.")
        } else if physiqueDelta < -1 {
            lines.append("Your physique score dropped recently.")
        } else {
            lines.append("Your physique is stable with no major change.")
        }

        // Drivers
        if taperDelta > 0.05 {
            lines.append("V-taper and upper structure are improving.")
        }

        if fatDelta < -0.02 {
            lines.append("Fat distribution is improving.")
        } else if fatDelta > 0.02 {
            lines.append("Fat accumulation is increasing.")
        }

        if postureDelta > 3 {
            lines.append("Posture quality has improved noticeably.")
        }

        // Focus suggestion
        if fatDelta > 0.02 {
            lines.append("Focus next: fat control, core tightening, daily steps.")
        } else if taperDelta < 0.02 {
            lines.append("Focus next: back and shoulder development.")
        } else {
            lines.append("Focus next: maintain consistency and progressive overload.")
        }

        return lines.joined(separator: " ")
    }
}
