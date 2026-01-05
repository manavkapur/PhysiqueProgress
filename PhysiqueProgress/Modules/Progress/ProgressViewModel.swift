//
//  ProgressViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//
import Foundation

import Foundation
import UIKit


final class ProgressViewModel {
    
    private let repository = ProgressRepository()
    private(set) var entries: [ProgressEntry] = []
    
    func load() {
        entries = repository.loadAll().sorted { $0.date < $1.date }
    }
    
    func entry(at index: Int) -> ProgressEntry? {
        guard index < entries.count else { return nil }
        return entries[index]
    }
    
    var count: Int { entries.count }

    // MARK: - Averages

    func averageOverallScore() -> Double {
        guard !entries.isEmpty else { return 0 }
        return entries.map { $0.overallScore }.reduce(0, +) / Double(entries.count)
    }
    
    func averagePhysiqueScore() -> Double {
        guard !entries.isEmpty else { return 0 }
        return entries.map { $0.physiqueScore }.reduce(0, +) / Double(entries.count)
    }

    // MARK: - Trends (THIS IS WHERE YOUR APP BECOMES UNIQUE)

    func overallScores() -> [Double] {
        entries.map { $0.overallScore }
    }

    func physiqueScores() -> [Double] {
        entries.map { $0.physiqueScore }
    }

    func fatIndexProgress() -> [Double] {
        entries.map { $0.fatIndex }
    }

    func vTaperProgress() -> [Double] {
        entries.map { $0.vTaper }
    }

    // MARK: - Progress insight

    func improvement() -> Double {
        guard entries.count >= 2 else { return 0 }
        return entries.last!.overallScore - entries.first!.overallScore
    }

    func physiqueImprovement() -> Double {
        guard entries.count >= 2 else { return 0 }
        return entries.last!.physiqueScore - entries.first!.physiqueScore
    }

    func latestEntry() -> ProgressEntry? {
        entries.last
    }

}
