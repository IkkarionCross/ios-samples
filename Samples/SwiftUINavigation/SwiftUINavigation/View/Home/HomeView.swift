//
//  ContentView.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 10/10/25.
//

import SwiftUI
import SwiftData

internal struct HomeView: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @ObservedObject
    private var listViewModel: LinkListViewModel
    
    internal init(
        listViewModel: LinkListViewModel
    ) {
        self.listViewModel = listViewModel
    }

    internal var body: some View {
        switch listViewModel.state {
        case .loading:
            AnyView(ProgressView())
        case .failed(let error):
            AnyView(
                VStack {
                    Text("Error: \(error.localizedDescription)")
                        .padding()
                        .accessibilityIdentifier("error_message")
                    HStack {
                        Spacer()
                        Button("Try Again") {
                            listViewModel.tryAgain()
                        }
                        Spacer()
                    }
                }
            )
        case .loaded(let link):
           AnyView(
                VStack {
                    AddLinkView { link in
                        addItem(item: link)
                    }
                    Text("Last shortened url")
                    if let orignalUrl = link?.originalURL {
                        Text("\(orignalUrl)")
                    } else {
                        Text("No links shortened yet.")
                    }
                    Spacer()
                    Button("Recently shortened links") {
                        listViewModel.goToRecentLinks()
                    }
                    
                }
                .onAppear {
                    updateLinks()
                }
                .padding()
           )
        }
    }

    private func updateLinks() {
        withAnimation {
            do {
                try listViewModel.updateLinks()
            } catch {
                print("Failed to fetch links: \(error)")
            }
        }
    }
    
    private func addItem(item: String) {
        Task {
            await listViewModel.add(link: item)
        }
    }
}

#Preview {
    HomeView(listViewModel: LinkListViewModel(coordinator: AppCoordinator()))
        .modelContainer(for: SavedLink.self, inMemory: true)
        .environmentObject(ShortenerService())
}
