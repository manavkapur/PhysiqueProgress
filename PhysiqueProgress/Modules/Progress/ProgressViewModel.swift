//
//  ProgressViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

final class ProgressViewModel {
    
    private let repository = ProgressRepository()
    private(set) var entries: [ProgressEntry] = []
    
    func load(){
        entries = repository.loadAll()
    }
    
    func entry(at index: Int) -> ProgressEntry? {
        entries[index]
    }
    
    var count: Int {
        entries.count
    }
    
    func averageOverallScore() -> Double {
        guard !entries.isEmpty else { return 0}
        let total = entries.reduce(0) { $0 + $1.overallScore }
        return total / Double(entries.count)
    }
    
    
}
