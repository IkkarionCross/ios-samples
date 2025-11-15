//
//  ListLinkView.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 11/10/25.
//

import SwiftUI

internal struct ListLinkView: View {
    
    @ObservedObject
    internal var viewModel: LinkListViewModel
    
    internal init(viewModel: ObservedObject<LinkListViewModel>) {
        self._viewModel = viewModel
    }
    
    internal var body: some View {
        List {
            ForEach(viewModel.links) { item in
                Text(item.originalURL)
                    .onTapGesture {
                        viewModel.goToDetail(item: item)
                    }
            }
        }
        .accessibilityIdentifier("list_link_view")
    }
}
