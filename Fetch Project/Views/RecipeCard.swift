// RecipeCard.swift
import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImageView(url: recipe.photoSmall)
                .frame(height: 150)
                .clipped()
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    if recipe.sourceURL != nil {
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                    }
                    
                    if recipe.youtubeURL != nil {
                        Image(systemName: "play.rectangle")
                            .foregroundColor(.red)
                    }
                }
                .font(.caption)
            }
            .padding(.vertical, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
