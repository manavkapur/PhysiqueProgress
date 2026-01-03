//
//  LocalFileManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import UIKit

final class CacheManager {
    
    static let shared = CacheManager()
    
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    
    func cacheImage(
        _ image: UIImage,
        forKey key: String
    
    ){
        cache.setObject(image, forKey: key as NSString)
    }
    
    func getCachedImage(
        forkey key: String
    ) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func clear(){
        cache.removeAllObjects()
    }
    
}
