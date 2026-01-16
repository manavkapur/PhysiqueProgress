//
//  ResultInsightView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class ResultInsightView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.numberOfLines = 0
        addSubview(label)
        label.pinEdges(to: self, inset: 16)
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 16
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with model: InsightModel) {
        label.text = """
        💡 \(model.title)

        ✅ Strength: \(model.strength)
        ⚠️ Weakness: \(model.weakness)

        👉 \(model.action)
        """
    }
}
