//
//  RecipesAPITests.swift
//  RecipesAPITests
//
//  Created by Tobias Fu on 4/22/25.
//

import Testing
import Foundation

@testable import Fetch_Project

// Helper thrown when fixtures are missing
struct FixtureError: Error {}

@Suite("Recipes API")
struct RecipesAPISuite {
    
    /// Locate JSON fixture in test bundle
    func fixtureURL(_ name: String) throws -> URL {
        // Get the bundle containing the test class
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: name, withExtension: "json")
        else { throw FixtureError() }
        
        return url
    }
    // MARK: – Happy path
    @Test("Decodes a non‑empty list")
    func happyPath() async throws {
        let url = try fixtureURL("recipes")
        let recipes = try await RecipesAPI.fetchRecipes(from: url)
        #expect(!recipes.isEmpty)                       // ➜ passes if list not empty
    }
    
    // MARK: – Empty list
    @Test("Throws .empty when list is empty")
    func emptyList() async throws {
        let url = try fixtureURL("recipes-empty")
        do {
            _ = try await RecipesAPI.fetchRecipes(from: url)
            #require(false, "Should have thrown .empty")   // instant failure
        } catch let error as RecipesAPI.APIError {
            #expect(error == .empty)
        }
    }
    
    // MARK: – Malformed payload
    @Test("Throws .malformedJSON for bad data")
    func malformed() async throws {
        let url = try fixtureURL("recipes-malformed")
        do {
            _ = try await RecipesAPI.fetchRecipes(from: url)
            #require(false, "Should have thrown .malformedJSON")
        } catch let error as RecipesAPI.APIError {
            #expect(error == .malformedJSON)
        }
    }
    
}
