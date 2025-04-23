//
//  RecipesViewModel.swift
//  Fetch Project
//
//  Created by Tobias Fu on 4/23/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipesViewModel: ObservableObject {
    enum LoadState {
        case idle
        case loading
        case loaded([Recipe])
        case error(Error)
        
        var recipes: [Recipe] {
            if case .loaded(let recipes) = self {
                return recipes
            }
            return []
        }
    }
    
    @Published private(set) var state: LoadState = .idle
    
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
}
