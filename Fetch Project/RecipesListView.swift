//
//  RecipesListView.swift
//  Fetch Project
//
//  Created by Tobias Fu on 4/22/25.
//

import SwiftUI

struct RecipesListView: View {
    var body: some View {
        NavigationStack {
            Text("Hello Recipes")
                .navigationTitle("Recipes")
        }
    }
}

#Preview { RecipesListView() }

#Preview("Network call") {
    RecipesListView()
        .task {
            do {
                let r = try await RecipesAPI.fetchRecipes()
                print("Got \(r.count) recipes")
            } catch { print(error) }
        }
}
