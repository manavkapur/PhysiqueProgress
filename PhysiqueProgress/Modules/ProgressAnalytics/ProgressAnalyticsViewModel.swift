//
//  ProgressAnalyticsViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//
import Foundation

// MARK: - Coverage Mode

enum ProgressCoverageMode {
    case overall
    case full
    case upper

    var bodyCoverage: BodyCoverageType? {
        switch self {
        case .overall: return nil
        case .full: return .full
        case .upper: return .upper
        }
    }
}

// MARK: - ViewModel

final class ProgressAnalyticsViewModel {

    // MARK: - State

    private let engine: ProgressAnalyticsEngine

    private(set) var coverageMode: ProgressCoverageMode = .overall
    private(set) var timeRange: TimeRange = .days30

    // MARK: - Init

    init(entries: [ProgressEntry]) {
        self.engine = ProgressAnalyticsEngine(entries: entries)
    }

    // MARK: - Mode Updates

    func setCoverage(_ mode: ProgressCoverageMode) {
        self.coverageMode = mode
    }

    func setRange(_ range: TimeRange) {
        self.timeRange = range
    }

    // MARK: - Hero Card

    func heroScore() -> Int {
        Int(engine.latest(coverage: coverageMode.bodyCoverage, range: timeRange)?.physiqueScore ?? 0)
    }

    func heroGrade() -> PhysiqueGrade {
        PhysiqueGrader.grade(from: Double(heroScore()))
    }

    func heroDelta() -> Double {
        engine.deltaPhysique(coverage: coverageMode.bodyCoverage, range: timeRange)
    }

    func heroSubtitle() -> String {
        switch coverageMode {
        case .overall: return "Overall physique trend"
        case .full: return "Full body trend"
        case .upper: return "Upper body trend"
        }
    }

    // MARK: - Core Charts

    func physiqueSeries() -> [Double] {
        engine.physiqueSeries(coverage: coverageMode.bodyCoverage, range: timeRange)
    }

    func overallSeries() -> [Double] {
        engine.overallSeries(coverage: coverageMode.bodyCoverage, range: timeRange)
    }

    // MARK: - Metric Charts

    func vTaperSeries() -> [Double] {
        engine.vTaperSeries(coverage: coverageMode.bodyCoverage, range: timeRange)
    }

    func fatIndexSeries() -> [Double] {
        engine.fatIndexSeries(coverage: coverageMode.bodyCoverage, range: timeRange)
    }

    func torsoSeries() -> [Double] {
        engine.torsoSeries(coverage: coverageMode.bodyCoverage, range: timeRange)
    }

    func postureSeries() -> [Double] {
        engine.postureSeries(coverage: coverageMode.bodyCoverage, range: timeRange)
    }

    func symmetrySeries() -> [Double] {
        engine.symmetrySeries(coverage: coverageMode.bodyCoverage, range: timeRange)
    }

    // MARK: - Latest Snapshot (cards)

    func latestVtaper() -> Double {
        engine.latest(coverage: coverageMode.bodyCoverage, range: timeRange)?.vTaper ?? 0
    }

    func latestFatIndex() -> Double {
        engine.latest(coverage: coverageMode.bodyCoverage, range: timeRange)?.fatIndex ?? 0
    }

    func latestTorso() -> Double {
        engine.latest(coverage: coverageMode.bodyCoverage, range: timeRange)?.torsoRatio ?? 0
    }

    func latestPosture() -> Double {
        engine.latest(coverage: coverageMode.bodyCoverage, range: timeRange)?.postureScore ?? 0
    }

    // MARK: - Consistency

    func scansPerWeek() -> Double {
        engine.scansPerWeek()
    }

    func bestStreak() -> Int {
        engine.bestStreakDays()
    }

    // MARK: - Insights

    func insightText() -> String {
        engine.insight(coverage: coverageMode.bodyCoverage, range: timeRange)
    }
}
