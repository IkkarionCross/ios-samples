//
//  AddLinkViewTest.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 13/10/25.
//

import SnapshotTesting
import SwiftUI
import Testing

@testable import SwiftUINavigation

@MainActor
struct AddLinkViewTest {
    
    @Test
    func shouldShowPlaceHolder() throws {
        
        let addLinkView = AddLinkView() { item in }
        
        let view: UIView = UIHostingController(rootView: addLinkView).view

        assertSnapshot(
            of: view,
            as: .image(size: view.intrinsicContentSize)
        )
       
    }
    
    @Test
    func shouldShowLinkText() throws {
        
        let addLinkView = AddLinkView(linkText: "https://www.google.com") { item in }
        
        let view: UIView = UIHostingController(rootView: addLinkView).view

        assertSnapshot(
            of: view,
            as: .image(size: view.intrinsicContentSize)
        )
       
    }
    
}

