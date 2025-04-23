////
////  RecipeService.swift
////  Fetch Project
////
////  Created by Tobias Fu on 4/17/25.
////
//
//import Foundation
//
//protocol RecipeServiceProtocol {
//    func fetchRecipes() async throws -> [Recipe]
//}
//
//class RecipeService: RecipeServiceProtocol {
//    
//    private let apiURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
//    
//    func fetchRecipes() async throws -> [Recipe] {
//        var request = URLRequest(url: apiURL)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        // Check HTTP response
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200...299).contains(httpResponse.statusCode) else {
//            throw RecipeError.networkError
//        }
//        
//        do {
//            let recipesResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
//            return recipesResponse.recipes
//        } catch {
//            throw RecipeError.decodingError
//        }
//    }
//}
//
//enum RecipeError: Error {
//    case networkError
//    case decodingError
//    case emptyData
//    case malformedData
//}
//
//
