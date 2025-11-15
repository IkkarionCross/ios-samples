//
//  Untitled.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 23/10/25.
//
import SwiftUI

struct RecentLinksView: View {
    
    @ObservedObject
    private var listViewModel: LinkListViewModel
    
    init(
        listViewModel: LinkListViewModel
    ) {
        self.listViewModel = listViewModel
    }
    
    var body: some View {
        ListLinkView(viewModel: ObservedObject(wrappedValue: listViewModel))
            .navigationTitle("Recently shortened URLS")
            .onAppear() {
                do {
                    try listViewModel.updateLinks()
                } catch {
                    print("Error updating links: \(error)")
                }
            }
    }
    
}
