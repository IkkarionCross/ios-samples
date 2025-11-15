//
//  AddLinkView.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 11/10/25.
//

import SwiftUI

internal struct AddLinkView: View {
    
    internal var willAddItem: (@MainActor (String) -> Void)?
    
    @State
    private var linkText: String
    
    internal init(
        linkText: String = String(),
        willAddItem: (@MainActor (String) -> Void)?
    ) {
        self.linkText = linkText
        self.willAddItem = willAddItem
    }
    
    internal var body: some View {
        HStack(alignment: .center) {
            TextField("Enter URL", text: $linkText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    addItem()
                }
                .textCase(.lowercase)
            Button("Add") {
                addItem()
            }
        }
    }
    
    private func addItem() {
        willAddItem?(linkText)
    }
    
}
