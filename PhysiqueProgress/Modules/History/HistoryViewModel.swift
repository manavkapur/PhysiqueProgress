//
//  HistoryViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import UIKit

final class HistoryViewModel {

    private(set) var imageNames: [String] = []

    func loadImages() {
        imageNames = LocalFileManager.shared.getAllImageFileNames()
    }

    func imageName(at index: Int) -> String {
        imageNames[index]
    }

    var numberOfItems: Int {
        imageNames.count
    }
}
