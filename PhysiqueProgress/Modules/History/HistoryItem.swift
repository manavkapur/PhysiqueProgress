//
//  HistoryItem.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//
import Foundation
struct HistoryItem {
    let fileName: String
    let date: Date

    var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
