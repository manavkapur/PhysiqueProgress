//
//  ResultBreakdownView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class ResultBreakdownView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.numberOfLines = 0
        addSubview(label)
        label.pinEdges(to: self, inset: 16)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with model: BreakdownModel) {
        label.text = """
        Physique Breakdown

        V-taper: \(String(format: "%.2f", model.vTaper))
        Fat index: \(String(format: "%.2f", model.fatIndex))
        Torso dominance: \(String(format: "%.2f", model.torsoRatio))
        Frame balance: \(String(format: "%.2f", model.frame))
        """
    }
}
