//
//  ImageCache.swift
//  Fetch Project
//
//  Created by Tobias Fu on 4/23/25.
//

import Foundation
import UIKit

actor ImageCache {
    static let shared = ImageCache()
    
    private var cache: [URL: UIImage] = [:]
    private let fileManager = FileManager.default
    
    private var cacheDirectory: URL? {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("ImageCache")
    }
    
    private init() {
        createCacheDirectoryIfNeeded()
    }
    
    private func createCacheDirectoryIfNeeded() {
        guard let cacheDirectory = cacheDirectory else { return }
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            } catch {
                print("Error creating cache directory: \(error)")
            }
        }
    }
    
    func image(for url: URL) -> UIImage? {
        // Check memory cache first
        if let cachedImage = cache[url] {
            return cachedImage
        }
        
        // Then check disk cache
        if let image = loadImageFromDisk(for: url) {
            // Update memory cache
            cache[url] = image
            return image
        }
        
        return nil
    }
    
    func set(_ image: UIImage, for url: URL) {
        // Update memory cache
        cache[url] = image
        
        // Save to disk cache
        saveImageToDisk(image, for: url)
    }
    
    private func filePath(for url: URL) -> URL? {
        guard let cacheDirectory = cacheDirectory else { return nil }
        let fileName = url.absoluteString.hash.description
        return cacheDirectory.appendingPathComponent(fileName)
    }
    
    private func saveImageToDisk(_ image: UIImage, for url: URL) {
        guard let filePath = filePath(for: url),
              let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            try data.write(to: filePath)
        } catch {
            print("Error saving image to disk: \(error)")
        }
    }
    
    private func loadImageFromDisk(for url: URL) -> UIImage? {
        guard let filePath = filePath(for: url),
              fileManager.fileExists(atPath: filePath.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: filePath)
            return UIImage(data: data)
        } catch {
            print("Error loading image from disk: \(error)")
            return nil
        }
    }
    
    func clearCache() {
        cache.removeAll()
        
        guard let cacheDirectory = cacheDirectory else { return }
        
        do {
            let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            for fileURL in contents {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error clearing disk cache: \(error)")
        }
    }
}
