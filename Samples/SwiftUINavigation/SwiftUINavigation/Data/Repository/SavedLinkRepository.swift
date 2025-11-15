//
//  SavedLinkRepository.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 11/10/25.
//

import Foundation
import SwiftData

@MainActor
protocol SavedLinkRepositoryProtocol {
    func save(link: String, shortLink: String) -> SavedLink
    func fetchLinks() throws -> [SavedLink]
}

@MainActor
internal struct SavedLinkRepository: SavedLinkRepositoryProtocol {
    
    private var container: ModelContainer
    
    internal init(container: ModelContainer = DatabaseContainer.sharedModelContainer) {
        self.container = container
    }
    
    func save(link: String, shortLink: String) -> SavedLink {
        
        let newItem = SavedLink(
            timestamp: Date(),
            originalURL: link,
            shortURL: shortLink
        )
        
        container.mainContext.insert(newItem)
        
        return newItem
    }
    
    func fetchLinks() throws -> [SavedLink] {
        let request = FetchDescriptor<SavedLink>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        return try container.mainContext.fetch(request)
    }

}
