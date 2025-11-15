//
//  LinkListViewModel.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 10/10/25.
//

import SwiftUI

@MainActor
protocol LinkListViewModelProtocol: AnyObject {
    var links: [SavedLink] { get }
    func updateLinks() throws
    func goToRecentLinks()
}

@MainActor
internal class LinkListViewModel: ObservableObject, LinkListViewModelProtocol {
    
    internal enum State {
        case loading, loaded(SavedLink?), failed(Error)
    }
    
    internal enum LinkListError: LocalizedError {
        case invalidURL
        
        internal var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The provided URL is invalid."
            }
        }
        
    }
    
    @Published
    internal var links: [SavedLink]
    
    @Published
    internal var state: State = .loaded(nil)
    
    private var lastShortenedLink: SavedLink?
    
    @Published
    private var coordinator: Coordinator
    
    private let repository: SavedLinkRepositoryProtocol
    private let service: ShortenerServiceProtocol
    
    internal init(
        repository: SavedLinkRepositoryProtocol = SavedLinkRepository(),
        service: ShortenerServiceProtocol = ShortenerService(),
        coordinator: Coordinator
    ) {
        self.repository = repository
        self.service = service
        self.links = []
        self.coordinator = coordinator
    }
    
    internal func updateLinks() throws {
        links = try repository.fetchLinks()
        lastShortenedLink = links.first
        
        state = .loaded(lastShortenedLink)
    }
    
    internal func add(link: String) async {
        
        state = .loading
        
        do {
            
            guard link.lowercased().isValidURL() else {
                state = .failed(LinkListError.invalidURL)
                return
            }
            
            let response = try await service.shorten(url: link)
            
            lastShortenedLink = repository.save(link: link, shortLink: response.links.short)
            
            try updateLinks()
            
            state = .loaded(lastShortenedLink)
            
        } catch {
            state = .failed(error)
        }
    }
    
    internal func tryAgain() {
        state = .loaded(lastShortenedLink)
    }
    
    internal func goToDetail(item: SavedLink) {
        coordinator.push(page: AppCoordinator.Actions.detail(shortUrl: item.shortURL ?? String()))
    }
    
    internal func goToRecentLinks() {
        coordinator.push(page: AppCoordinator.Actions.recentLinks)
    }

}
