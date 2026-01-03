//
//  CacheManager.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

import UIKit

final class LocalFileManager {
    
    static let shared = LocalFileManager()
    private init() {}
    
    
    private let folderName = "PhysiquePhotos"
    
    private func photosDirectory() -> URL {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let directory = documents.appendingPathComponent(folderName)
        
        if !fileManager.fileExists(atPath: directory.path){
            try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        
        return directory
    }
    
    func saveImage( _ image: UIImage, fileName: String) -> URL? {
        
        let fileURL = photosDirectory().appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
        
        do{
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Image save failed ", error)
            return nil
        }
        
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let fileURL = photosDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func deleteImage(fileName: String) {
        let fileURL = photosDirectory().appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Image deletion failed ", error)
        }
    }
    
    func deleteAllImages() {
        try? FileManager.default.removeItem(at: photosDirectory())
    }
    
    func getAllImageFileNames() -> [String] {
        let directory = photosDirectory()
        let files = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        
        return files?
            .map{$0.lastPathComponent}
            .sorted(by: >) ?? []
    }
    
}
