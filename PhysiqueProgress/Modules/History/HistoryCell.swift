//
//  HistoryCell.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 04/01/26.
//

import UIKit

final class HistoryCell: UICollectionViewCell {
    
    static let reuseId = "HistoryCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with fileName: String){
        if let cached = CacheManager.shared.getCachedImage(forkey: fileName){
            imageView.image = cached
            return
        }
        
        if let image = LocalFileManager.shared.loadImage(fileName: fileName){
            CacheManager.shared.cacheImage(image, forKey: fileName)
            imageView.image = image
        }
    }
    
}
