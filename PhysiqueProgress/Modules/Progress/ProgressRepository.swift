//
//  ProgressRepository.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import Foundation

import FirebaseFirestore
import FirebaseAuth


final class ProgressRepository {
    private let fileName = "progress_metrics.json"
    
    
    func save(_ entry: ProgressEntry){
        var all = loadAll()
        all.append(entry)
        persist(all)
        
        syncToFirebase(entry)
    }
    
    func loadAll() ->[ProgressEntry]{
        guard
            let data = try? Data(contentsOf: fileURL()),
            let decoded = try? JSONDecoder().decode([ProgressEntry].self, from: data)
        else { return [] }
        return decoded
    }
    
    private func persist(_ entries: [ProgressEntry]){
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL())
    }
    
    private func fileURL() -> URL {
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return document.appendingPathComponent(fileName)
    }
    
    private func syncToFirebase(_ entry: ProgressEntry) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let data: [String: Any] = [
            "posture": entry.postureScore,
            "symmetry": entry.symmetryScore,
            "proportion": entry.proportionScore,
            "stability": entry.stabilityScore,
            "overall": entry.overallScore,
            "date": Timestamp(date: entry.date)
        ]

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("progress")
            .addDocument(data: data)
    }

}
