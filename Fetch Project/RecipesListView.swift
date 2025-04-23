// RecipesListView.swift
import SwiftUI
import Foundation
struct RecipesListView: View {
    @StateObject private var viewModel = RecipesViewModel()
    @State private var searchText = ""
    
    private var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return viewModel.recipes
        } else {
            return viewModel.recipes.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.cuisine.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Recipes")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            Task {
                                await viewModel.reload()
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search recipes or cuisines")
                .task {
                    if case .idle = viewModel.state {
                        await viewModel.loadRecipes()
                    }
                }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            loadingView
            
        case .loading:
            if viewModel.recipes.isEmpty {
                loadingView
            } else {
                recipesGridView
            }
            
        case .loaded:
            if viewModel.recipes.isEmpty {
                emptyView
            } else if filteredRecipes.isEmpty && !searchText.isEmpty {
                noSearchResultsView
            } else {
                recipesGridView
            }
            
        case .error(let error):
            errorView(error: error)
        }
    }
    
    private var loadingView: some View {
        ProgressView("Loading recipes...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        VStack {
            Image(systemName: "fork.knife")
                .font(.largeTitle)
                .padding()
            Text("No Recipes")
                .font(.headline)
            Text("There are no recipes available at this time.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private var noSearchResultsView: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .padding()
            Text("No Matching Recipes")
                .font(.headline)
            Text("Try a different search term.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private func errorView(error: Error) -> some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .padding()
            Text("Could not load recipes")
                .font(.headline)
            Text(errorDescription(for: error))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await viewModel.reload()
                }
            }
            .buttonStyle(.bordered)
            .padding(.top)
        }
        .padding()
    }
    
    private var recipesGridView: some View {
        ScrollView {
            if case .loading = viewModel.state {
                ProgressView()
                    .padding(.top)
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                ForEach(filteredRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        RecipeCard(recipe: recipe)
                            .frame(height: 220)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .refreshable {
            await viewModel.reload()
        }
    }
    
    private func errorDescription(for error: Error) -> String {
        if let apiError = error as? RecipesAPI.APIError {
            switch apiError {
            case .empty:
                return "No recipes found."
            case .badStatus(let code):
                return "Server error (Status \(code))"
            case .malformedJSON:
                return "The recipes data was not in the expected format."
            }
        }
        return "An unknown error occurred: \(error.localizedDescription)"
    }
}
