//
//  ResultActionView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//

import UIKit

final class ResultActionView: UIView {

    var onProgress: (() -> Void)?

    private let button = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        button.setTitle("View Progress", for: .normal)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        addSubview(button)
        button.pinEdges(to: self, inset: 16)
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure() {}

    @objc private func tap() {
        onProgress?()
    }
}
