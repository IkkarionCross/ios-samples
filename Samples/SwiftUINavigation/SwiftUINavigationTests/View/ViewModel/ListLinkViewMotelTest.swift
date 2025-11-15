//
//  ListLinkViewMotelTest.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 12/10/25.
//

import Foundation
import Testing
@testable import SwiftUINavigation

@MainActor
struct ListLinkViewMotelTest {
    
    var sut: LinkListViewModel!
    var repositoryMock: SavedLinkRepositoryMock!
    var serviceMock: ShortenerServiceMock!
    var coordinatorMock: CoordinatorMock!
    
    init() {
        repositoryMock = SavedLinkRepositoryMock()
        serviceMock = ShortenerServiceMock()
        coordinatorMock = CoordinatorMock()
        
        sut = LinkListViewModel(
            repository: repositoryMock,
            service: serviceMock,
            coordinator: coordinatorMock
        )
        
    }
    
    @Test
    func shouldAddLink() async throws {
        let link = "https://www.example.com"
        
        serviceMock.shortenResponse = .dummy(withOriginalUrl: link)
        
        await sut.add(link: link)
        
        if case .loaded = sut.state { } else {
            #expect(Bool(false))
        }
    
        #expect(repositoryMock.saveLinkCalled == true)
        #expect(repositoryMock.links.count == 1)
        #expect(serviceMock.shortenURLCalled == true)
        #expect(sut.links.count == 1)
        
    }
    
    @Test
    func shouldNOTAddLink_NotValidURL() async throws {
        let notValidUrl = "hts://www.example.com"
        
        await sut.add(link: notValidUrl)
        
        if case .failed(let error) = sut.state {
            #expect(error.localizedDescription == LinkListViewModel.LinkListError.invalidURL.localizedDescription)
        } else {
            #expect(Bool(false))
        }
    
        #expect(repositoryMock.saveLinkCalled == false)
        #expect(repositoryMock.links.count == 0)
        #expect(serviceMock.shortenURLCalled == false)
        #expect(sut.links.count == 0)
        
    }
    
    @Test
    func shouldNOTAddLink_ServiceError() async throws {
        let link = "https://www.example.com"
        
        serviceMock.shortenError = HttpClient.HttpError.notFound
        
        await sut.add(link: link)
        
        if case .failed(let error) = sut.state {
            #expect(error as? HttpClient.HttpError == HttpClient.HttpError.notFound)
        } else {
            #expect(Bool(false))
        }
    
        #expect(repositoryMock.saveLinkCalled == false)
        #expect(repositoryMock.links.count == 0)
        #expect(serviceMock.shortenURLCalled == true)
        #expect(sut.links.count == 0)
        
    }
    
    @Test
    func shouldNOTAddLink_UpdateLinksFailed() async throws {
        let link = "https://www.example.com"
        
        serviceMock.shortenResponse = .dummy(withOriginalUrl: link)
        repositoryMock.fetchLinksError = NSError(domain: "Test", code: 1)
        
        await sut.add(link: link)
        
        if case .failed(let error) = sut.state {
            #expect(error as NSError == NSError(domain: "Test", code: 1))
        } else {
            #expect(Bool(false))
        }
    
        #expect(repositoryMock.saveLinkCalled == true)
        #expect(repositoryMock.links.count == 1)
        #expect(serviceMock.shortenURLCalled == true)
        #expect(sut.links.count == 0)
        
    }
    
    @Test
    func shouldTryAgain() async throws {
        
        sut.state = .failed(NSError(domain: "Test", code: 1))
        
        sut.tryAgain()
        
        if case .loaded = sut.state { } else {
            #expect(Bool(false))
        }
        
    }
    
    @Test
    func shouldUpdateLinks_LastShortnedLinkIsNil() async throws {
        
        try sut.updateLinks()
        
        if case .loaded(let savedLink) = sut.state {
            #expect(savedLink == nil)
        } else {
            #expect(Bool(false))
        }
        
        #expect(repositoryMock.fetchLinksCalled == true)
        
    }
    
    @Test
    func shouldUpdateLinks_LastShortnedLinkNoNil() async throws {
        
        let expectedLink =  SavedLink.dummy()
        repositoryMock.links = [ SavedLink.dummy() ]
        
        try sut.updateLinks()
        
        if case .loaded(let savedLink) = sut.state {
            #expect(savedLink?.originalURL == expectedLink.originalURL)
        } else {
            #expect(Bool(false))
        }
        
        #expect(repositoryMock.fetchLinksCalled == true)
        
    }
    
    @Test
    func shouldGoToDetail() async throws {
        
        sut.goToDetail(item: SavedLink.dummy())
        
        if case .detail = coordinatorMock.pushedPage as? AppCoordinator.Actions {
            
        } else {
            #expect(Bool(false))
        }
        
        #expect(coordinatorMock.pushCalled == true)
    }
    
    @Test
    func shouldGoToRecentLinks() {
        
        sut.goToRecentLinks()
        
        if case .recentLinks = coordinatorMock.pushedPage as? AppCoordinator.Actions {
            
        } else {
            #expect(Bool(false))
        }
        
        #expect(coordinatorMock.pushCalled == true)
    }
    
    
}

