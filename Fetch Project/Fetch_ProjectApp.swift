//
//  Fetch_ProjectApp.swift
//  Fetch Project
//
//  Created by Tobias Fu on 4/14/25.
//

import SwiftUI

@main
struct Fetch_ProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
