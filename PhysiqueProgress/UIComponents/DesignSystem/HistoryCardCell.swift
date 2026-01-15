//
//  HistoryCardCell.swift
//  PhysiqueProgress
//

import UIKit

final class HistoryCardCell: UICollectionViewCell {

    static let reuseId = "HistoryCardCell"

    private let container = UIView()
    private let imageView = UIImageView()
    private let gradient = CAGradientLayer()

    private let dateLabel = UILabel()
    private let datePill = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }

    private func buildUI() {
        backgroundColor = .clear

        // Card container
        container.backgroundColor = AppColors.card
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false

        // Image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Gradient overlay
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.75).cgColor
        ]
        gradient.locations = [0.55, 1.0]
        container.layer.addSublayer(gradient)

        // Date pill
        datePill.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        datePill.layer.cornerRadius = 10
        datePill.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        dateLabel.textColor = .white
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        datePill.addSubview(dateLabel)
        container.addSubview(imageView)
        container.addSubview(datePill)
        contentView.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            datePill.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            datePill.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),

            dateLabel.topAnchor.constraint(equalTo: datePill.topAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: datePill.bottomAnchor, constant: -4),
            dateLabel.leadingAnchor.constraint(equalTo: datePill.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: datePill.trailingAnchor, constant: -8)
        ])

        // Enterprise shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.35
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.masksToBounds = false
    }

    // MARK: - Public

    func configure(item: HistoryItem) {

        dateLabel.text = item.date.formatted(date: .abbreviated, time: .omitted)

        if let cached = CacheManager.shared.getCachedImage(forkey: item.fileName) {
            imageView.image = cached
            return
        }

        if let image = LocalFileManager.shared.loadImage(fileName: item.fileName) {
            CacheManager.shared.cacheImage(image, forKey: item.fileName)
            imageView.image = image
        }
    }
}
