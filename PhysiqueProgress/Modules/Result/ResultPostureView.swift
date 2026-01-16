//
//  ResultPostureView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class ResultPostureView: UIView {

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

    func configure(with model: PostureModel) {
        label.text = """
        Form & Posture

        Posture: \(Int(model.posture))
        Symmetry: \(Int(model.symmetry))
        Stability: \(Int(model.stability))
        """
    }
}
