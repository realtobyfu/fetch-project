//
//  CachedImageView.swift
//  Fetch Project
//
//  Created by Tobias Fu on 4/23/25.
//
import Foundation
import SwiftUI

struct CachedImageView: View {
    let url: URL?
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
                    .opacity(0.3)
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url, !isLoading else { return }
        
        isLoading = true
        
        // Check cache first
        if let cachedImage = await ImageCache.shared.image(for: url) {
            image = cachedImage
            isLoading = false
            return
        }
        
        // Download if not cached
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                await ImageCache.shared.set(downloadedImage, for: url)
                image = downloadedImage
            }
        } catch {
            print("Error loading image: \(error)")
        }
        
        isLoading = false
    }
}
