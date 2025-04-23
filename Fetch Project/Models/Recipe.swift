//
//  Recipe.swift
//  Fetch Project
//
//  Created by Tobias Fu on 4/17/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: UUID        // maps from “uuid”
    let name: String
    let cuisine: String
    let photoLarge: URL?
    let photoSmall: URL?
    let sourceURL: URL?
    let youtubeURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid", name, cuisine
        case photoLarge = "photo_url_large"
        case photoSmall = "photo_url_small"
        case sourceURL  = "source_url"
        case youtubeURL = "youtube_url"
    }
}
