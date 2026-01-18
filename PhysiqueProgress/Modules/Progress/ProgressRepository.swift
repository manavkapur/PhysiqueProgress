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
    private var fileName: String {
        let uid = Auth.auth().currentUser?.uid ?? "guest"
        return "progress_\(uid).json"
    }
    
    
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

    
    private func syncToFirebase(_ entry: ProgressEntry) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let data: [String: Any] = [

            // 🔹 SYSTEM
            "id": entry.id,
            "imageFileName": entry.imageFileName,
            "date": Timestamp(date: entry.date),
            "weekOfYear": entry.weekOfYear,
            "engineVersion": entry.engineVersion,

            // 🔹 USER METADATA
            "height": entry.height,
            "weight": entry.weight as Any,
            "poseQuality": entry.poseQuality,

            // 🔹 FINAL SCORES
            "overallScore": entry.overallScore,
            "physiqueScore": entry.physiqueScore,

            // 🔹 POSE QUALITY
            "postureScore": entry.postureScore,
            "symmetryScore": entry.symmetryScore,
            "stabilityScore": entry.stabilityScore,

            // 🔹 TRUE BODY SHAPE
            "vTaper": entry.vTaper,
            "waistHip": entry.waistHip,
            "fatIndex": entry.fatIndex,
            "torsoRatio": entry.torsoRatio,
            "shoulderThigh": entry.shoulderThigh,
            
            "coverage": entry.coverage.rawValue,            
        ]

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("progress")
            .document(entry.id) // 👈 better than addDocument
            .setData(data, merge: true)
    }
    func migrateGuestIfNeeded() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let guestURL = document.appendingPathComponent("progress_guest.json")
        let userURL = document.appendingPathComponent("progress_\(uid).json")

        if FileManager.default.fileExists(atPath: guestURL.path),
           !FileManager.default.fileExists(atPath: userURL.path) {

            do {
                try FileManager.default.moveItem(at: guestURL, to: userURL)
                print("✅ Migrated guest progress → user:", uid)
            } catch {
                print("❌ Failed to migrate guest progress:", error.localizedDescription)
            }
        }
    }


}
