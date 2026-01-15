//
//  EnterpriseActionSheet.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 15/01/26.
//

import UIKit

final class EnterpriseActionSheet: UIViewController {

    var onCamera: (() -> Void)?
    var onGallery: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        buildSheet()
    }

    private func buildSheet() {

        let card = CardView()

        let title = UILabel()
        title.text = "Add progress photo"
        title.textColor = .white
        title.font = .systemFont(ofSize: 20, weight: .semibold)

        let subtitle = UILabel()
        subtitle.text = "Choose how you want to add your photo"
        subtitle.textColor = .systemGray
        subtitle.font = .systemFont(ofSize: 14)

        let camera = PrimaryButton(title: "📸  Take Photo")
        let gallery = PrimaryButton(title: "🖼️  Choose from Gallery")

        let cancel = UIButton(type: .system)
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(.systemBlue, for: .normal)
        cancel.addTarget(self, action: #selector(close), for: .touchUpInside)

        camera.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        gallery.addTarget(self, action: #selector(openGallery), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            title, subtitle, camera, gallery, cancel
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(stack)
        view.addSubview(card)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -22),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),

            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            card.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    @objc private func takePhoto() {
        dismiss(animated: true) { self.onCamera?() }
    }

    @objc private func openGallery() {
        dismiss(animated: true) { self.onGallery?() }
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}
