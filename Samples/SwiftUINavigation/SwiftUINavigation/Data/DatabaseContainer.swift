//
//  DatabaseContainer.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 11/10/25.
//

import SwiftData

final internal class DatabaseContainer {
    
    @MainActor
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedLink.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
}
