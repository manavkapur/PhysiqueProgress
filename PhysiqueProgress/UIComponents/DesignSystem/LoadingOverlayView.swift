//
//  LoadingOverlayView.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 18/01/26.
//

import UIKit

final class LoadingOverlayView: UIView {

    private let spinner = UIActivityIndicatorView(style: .large)
    private let label = UILabel()

    init(text: String) {
        super.init(frame: .zero)

        backgroundColor = UIColor.black.withAlphaComponent(0.45)
        translatesAutoresizingMaskIntoConstraints = false

        spinner.startAnimating()
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false

        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(spinner)
        addSubview(label)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 12),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
