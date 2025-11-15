//
//  SavedLinkRepositoryMock.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 12/10/25.
//

import Foundation
@testable import SwiftUINavigation

final class SavedLinkRepositoryMock: SavedLinkRepositoryProtocol {
   
    var links: [SavedLink] = []
    
    var saveLinkCalled = false
    var fetchLinksCalled = false
    var fetchLinksError: Error?
    
    func save(link: String, shortLink: String) -> SavedLink {
        saveLinkCalled = true
        let newLink = SavedLink(
            timestamp: Date(),
            originalURL: link,
            shortURL: shortLink
        )
        links.append(newLink)
        
        return newLink
    }
    
    func fetchLinks() throws -> [SavedLink] {
        fetchLinksCalled = true
        
        if let error = fetchLinksError {
            throw error
        }
        
        return links
    }
}

