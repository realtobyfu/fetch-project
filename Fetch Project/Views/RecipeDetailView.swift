//
//  RecipeDetailView.swift
//  Fetch Project
//
//  Created by Tobias Fu on 4/23/25.
//

import Foundation
import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedImageView(url: recipe.photoLarge)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(recipe.cuisine)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    if let sourceURL = recipe.sourceURL {
                        Link(destination: sourceURL) {
                            Label("View Recipe Source", systemImage: "link")
                        }
                        .padding(.vertical, 2)
                    }
                    
                    if let youtubeURL = recipe.youtubeURL {
                        Link(destination: youtubeURL) {
                            Label("Watch Video Tutorial", systemImage: "play.rectangle.fill")
                        }
                        .foregroundColor(.red)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
