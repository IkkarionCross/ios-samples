//
//  AppCoordinatorTests.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 13/10/25.
//

import Testing
import SwiftUI

@testable import SwiftUINavigation

@MainActor
final class AppCoordinatorTests {
    
    
    var sut: AppCoordinator = AppCoordinator()
    
    @Test
    func shouldRootBeSet() {
        #expect(sut.root is HomeView)
    }
    
    @Test
    func shouldPush() throws {
        
        sut.push(page: AppCoordinator.Actions.detail(shortUrl: "abc123"))
        
        #expect(sut.path.count == 1)
        
    }
    
    @Test
    func shouldSheet() throws {
        
        sut.sheet(page: AppCoordinator.Actions.detail(shortUrl: "abc123"))
        
        #expect(sut.sheet != nil)
        
    }
    
    @Test
    func shouldDimissSheet() throws {
        sut.sheet(page: AppCoordinator.Actions.detail(shortUrl: "abc123"))
        
        #expect(sut.sheet != nil)
        sut.dismissSheet()
        #expect(sut.sheet == nil)
    }
    
    @Test
    func shouldPop() throws {
        sut.push(page: AppCoordinator.Actions.detail(shortUrl: "abc123"))
        #expect(sut.path.count == 1)
        sut.pop()
        #expect(sut.path.count == 0)
    }
    
    @Test
    func shouldFullScreenCover() throws {
        
        sut.fullScreenCover(page: AppCoordinator.Actions.detail(shortUrl: "abc123"))
        
        #expect(sut.fullScreenCover != nil)
        
    }
    
    @Test
    func shouldDimissFullScreenCover() throws {
        sut.fullScreenCover(page: AppCoordinator.Actions.detail(shortUrl: "abc123"))
        
        #expect(sut.fullScreenCover != nil)
        sut.dismissFullScreenCover()
        #expect(sut.fullScreenCover == nil)
    }
    
    @Test
    func shouldPopToRoot() async throws {
        sut.push(page: AppCoordinator.Actions.detail(shortUrl: "abc1"))
        sut.push(page: AppCoordinator.Actions.detail(shortUrl: "abc2"))
        sut.push(page: AppCoordinator.Actions.detail(shortUrl: "abc3"))
        #expect(sut.path.count == 3)
        sut.popToRoot()
        #expect(sut.path.count == 0)
    }
    
    @Test
    func shouldCreateRecentLinks() {
        let view = sut.handle(action: .recentLinks)
        
        #expect(view as? RecentLinksView != nil)
    }
    
    @Test
    func shouldCreateDetail() {
        let view = sut.handle(action: .detail(shortUrl: "https://www.nubank.com.br"))
        
        #expect(view is LinkDetailView)
    }

    
}

