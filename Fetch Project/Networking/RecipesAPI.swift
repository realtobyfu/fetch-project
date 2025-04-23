//
//  RecipesAPI.swift
//  Fetch Project
//
//  Created by Tobias Fu on 4/22/25.
//

import Foundation

enum RecipesAPI {
    
    // MARK: – Public
    
    enum APIError: Error, Equatable {
        static func == (lhs: RecipesAPI.APIError, rhs: RecipesAPI.APIError) -> Bool {
            switch (lhs, rhs) {
            case (.badStatus(let lhsStatus), .badStatus(let rhsStatus)):
                return lhsStatus == rhsStatus
            case (.empty, .empty):
                return true
            case (.malformedJSON(let lhsError), .malformedJSON(let rhsError)):
                return (lhsError as NSError) == (rhsError as NSError)
            default:
                return false
            }
        }
        
        case badStatus(Int)
        case empty
        case malformedJSON(Error)
    }
    
    static func fetchRecipes(
        from url: URL = Self.productionURL
    ) async throws -> [Recipe] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard
            let http = response as? HTTPURLResponse,
            (200..<300).contains(http.statusCode)
        else { throw APIError.badStatus((response as? HTTPURLResponse)?.statusCode ?? -1) }  // async/await URLSession :contentReference[oaicite:1]{index=1}
        
        do {
            let decoder = JSONDecoder()
            let top = try decoder.decode(TopLevel.self, from: data)
            guard !top.recipes.isEmpty else { throw APIError.empty }
            return top.recipes
        } catch {
            throw APIError.malformedJSON(error)
        }
    }
    
    // MARK: – Private
    
    private struct TopLevel: Decodable { let recipes: [Recipe] }
    private static let productionURL = URL(string:
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
}
