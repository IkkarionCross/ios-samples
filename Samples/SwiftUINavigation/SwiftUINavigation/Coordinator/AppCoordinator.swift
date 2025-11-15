//
//  Coordinator.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 13/10/25.
//

import SwiftUI

@MainActor
internal protocol Coordinator {
    func push(page: some AppCoordinator.Displayable)
    func sheet(page: some AppCoordinator.Displayable)
    func fullScreenCover(page: some AppCoordinator.Displayable)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenCover()
}

@MainActor
internal class AppCoordinator: Coordinator, ObservableObject {
    
    @Published
    internal var path: NavigationPath = NavigationPath()
    
    @Published
    internal private(set) var sheet: (any Displayable)?
    
    @Published
    internal private(set) var fullScreenCover: (any Displayable)?
    
    internal lazy var root: some View = {
        HomeView(listViewModel: LinkListViewModel(coordinator: self))
    }()
    
    internal func push(page: some Displayable) {
        path.append(page)
    }
    
    internal func sheet(page: some Displayable) {
        self.sheet = page
    }
    
    internal func fullScreenCover(page: some Displayable) {
        self.fullScreenCover = page
    }
    
    internal func pop() {
        path.removeLast()
    }
    
    internal func popToRoot() {
        path.removeLast(path.count)
    }
    
    internal func dismissSheet() {
        sheet = nil
    }
    
    internal func dismissFullScreenCover() {
        fullScreenCover = nil
    }
    
    @ViewBuilder
    internal func handle(action: Actions) -> some View {
        switch action {
        case .detail(let shortUrl):
            LinkDetailView(shortLink: shortUrl)
        case .recentLinks:
            RecentLinksView(listViewModel: LinkListViewModel(coordinator: self))
        }
    }
}

extension AppCoordinator {
    
    typealias Page = Identifiable & Hashable
    
    protocol Displayable: Page { }
    
    enum Actions: Displayable {
        case detail(shortUrl: String)
        case recentLinks
        
        var id: String {
            switch self {
            case .detail(let shortUrl):
                return "detail_\(shortUrl)"
            case .recentLinks:
                return "recentLinks"
            }
        }
        
    }

}
