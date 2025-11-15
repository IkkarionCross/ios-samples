//
//  CoordinatorMock.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 13/10/25.
//

@testable import SwiftUINavigation

@MainActor
final class CoordinatorMock: Coordinator {
    
    var pushCalled: Bool = false
    var sheetCalled: Bool = false
    var popCalled: Bool = false
    var fullscreenCoverCalled: Bool = false
    var popToRootCalled: Bool = false
    var dismissSheetCalled: Bool = false
    var dismissFullscreenCoverCalled: Bool = false
    
    var pushedPage: (any AppCoordinator.Displayable)?
    var sheetPage: (any AppCoordinator.Displayable)?
    var fullscreenCoverPage: (any AppCoordinator.Displayable)?
    
    
    func push(page: some AppCoordinator.Displayable) {
        pushCalled = true
        pushedPage = page
    }
    
    func sheet(page: some AppCoordinator.Displayable) {
        sheetCalled = true
        sheetPage = page
    }
    
    func fullScreenCover(page: some AppCoordinator.Displayable) {
        fullscreenCoverCalled = true
        fullscreenCoverPage = page
    }
    
    func pop() {
        popCalled = true
    }
    
    func popToRoot() {
        popToRootCalled = true
    }
    
    func dismissSheet() {
        dismissSheetCalled = true
    }
    
    func dismissFullScreenCover() {
        dismissFullscreenCoverCalled = true
    }
    
}
