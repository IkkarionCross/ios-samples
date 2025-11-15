//
//  SwiftUINavigationApp.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 10/10/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftUINavigationApp: App {
    
    @ObservedObject
    var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.root
                    .navigationDestination(for: AppCoordinator.Actions.self) { action in
                        coordinator.handle(action: action)
                    }
            }
            
        }
        .environmentObject(ShortenerService())
        .environmentObject(coordinator)
    }
}
