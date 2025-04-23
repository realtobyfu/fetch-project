//
//  RecipesViewModel.swift
//  Fetch Project
//
//  Created by Tobias Fu on 4/23/25.
//

// RecipesViewModel.swift
import Foundation
import SwiftUI

@MainActor
class RecipesViewModel: ObservableObject {
    enum LoadState {
        case idle
        case loading
        case loaded([Recipe])
        case error(Error)
    }
    
    @Published private(set) var state: LoadState = .idle
    
    var recipes: [Recipe] {
        if case .loaded(let recipes) = state {
            return recipes
        }
        return []
    }
    
    func loadRecipes() async {
        state = .loading
        
        do {
            let recipes = try await RecipesAPI.fetchRecipes()
            state = .loaded(recipes)
        } catch {
            state = .error(error)
        }
    }
    
    func reload() async {
        await loadRecipes()
    }
    
//    var isIdleOrInitialLoading: Bool {
//        if case .idle = state { return true }
//        if case .loading = state && recipes.isEmpty { return true }
//        return false
//    }
//
}
