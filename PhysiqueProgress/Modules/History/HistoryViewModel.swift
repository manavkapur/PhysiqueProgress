//
//  HistoryViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import UIKit
import Foundation

final class HistoryViewModel {

    private(set) var items: [HistoryItem] = []

    func loadImages() {
        let names = LocalFileManager.shared.getAllImageFileNames()

        items = names.compactMap { name in
            let date = extractDate(from: name) ?? Date()
            return HistoryItem(fileName: name, date: date)
        }

        items.sort { (a: HistoryItem, b: HistoryItem) in
            a.date > b.date
        }
    }

    func item(at index: Int) -> HistoryItem {
        items[index]
    }

    var numberOfItems: Int { items.count }

    private func extractDate(from name: String) -> Date? {
        let parts = name.replacingOccurrences(of: "progress_", with: "")
                        .replacingOccurrences(of: ".jpg", with: "")
        if let t = TimeInterval(parts) {
            return Date(timeIntervalSince1970: t)
        }
        return nil
    }
}
