//
//  ProgressRepository.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import Foundation

final class ProgressRepository {
    private let fileName = "progress_metrics.json"
    
    
    func save(_ entry: ProgressEntry){
        var all = loadAll()
        all.append(entry)
        persist(all)
    }
    
    func loadAll() ->[ProgressEntry]{
        guard
            let data = try? Data(contentsOf: fileURL()),
            let decoded = try? JSONDecoder().decode([ProgressEntry].self, from: data)
        else { return [] }
        return decoded
    }
    
    private func persist(_ entries: [ProgressEntry]) {
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: fileURL(), options: .atomic)
        } catch {
            print("❌ Failed to persist progress:", error)
        }
    }
    
    private func fileURL() -> URL {
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return document.appendingPathComponent(fileName)
    }


    
}
