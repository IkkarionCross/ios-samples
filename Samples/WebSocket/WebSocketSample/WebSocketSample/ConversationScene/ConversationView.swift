//
//  ConversationView.swift
//  ComponentLab
//
//  Created by victor amaro on 20/07/25.
//

import SwiftUI

public struct ConversationView: View {
    
    @State private var messages: [MessageCardModel]
    private let title: String
    private let service: WebSocketCodableService<String, String>
    
    @EnvironmentObject
    private var networkMonitor: NetworkMonitor
    
    public init(
        title: String,
        messages: [MessageCardModel],
        service: WebSocketCodableService<String, String> = WebSocketCodableService<String, String>(
            connectionFactory: WebSocketSessionFactory.self,
            encoder: JSONEncoder(),
            decoder: JSONDecoder()
        )
    ) {
        self.title = title
        self.messages = messages
        self.service = service
    }
    
    public var body: some View {
            ScrollViewReader { reader in
                MessagesListView(messages: messages)
                    .frame(maxHeight: .infinity)
                    .background(Color.clear)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.3)) {
                            reader.scrollTo(messages.last, anchor: .bottom)
                        }
                    }
                    .onChange(of: messages.count) { _, _ in
                        reader.scrollTo(messages.last, anchor: .bottom)
                    }
                    .onChange(of: networkMonitor.isConnected) { _, _ in
                        if networkMonitor.isConnected {
                            Task { @MainActor in
                                do {
                                    try await service.connect()
                                    print("connected")
                                } catch {
                                    print("Failed to connect: \(error)")
                                }
                            }
                        } else {
                            service.disconnect()
                            print("diconnected")
                        }
                    }
            }
            .toolbarRole(.editor)
            .toolbar(content: toolbarItens)
            .onAppear {
                Task {
                    do {
                        service.disconnect()
                        try await openAndReceiveChat()
                    } catch {
                        print("Failed to connect: \(error)")
                        
                    }
                }
            }
            TypeMessageView(service: service) { messageSent in
                messages.append(
                    MessageCardModel(
                        message: messageSent,
                        isSender: true,
                        image: nil,
                        timestamp: Date()
                    )
                )
            }
    }
    
    @ToolbarContentBuilder
    private func toolbarItens() -> some ToolbarContent {
        ToolbarItem(placement: .principal) { Color.clear }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                // Action for settings button
            }) {
                HStack(spacing: 20) {
                    Image(systemName: "camera")
                        .imageScale(.large)
                    Image(systemName: "phone")
                        .imageScale(.large)
                }
            }
        }
        
        ToolbarItem(placement: .topBarLeading) {
            
            HStack(spacing: 5) {
                Image(systemName: "person.crop.circle")
                    .imageScale(.large)
                Text(self.title)
                    .foregroundColor(.primary)
            }
            
        }
    }
    
    private func openAndReceiveChat() async throws {
        try await service.connect()
        for try await newMessage in service.receive() {
            messages.append(
                MessageCardModel(
                    message: newMessage,
                    isSender: false ,
                    image: nil,
                    timestamp: Date()
                )
            )
        }
    }

}

#Preview {
    VStack {
        NavigationStack {
            let messages = (0..<20).map { index in
                MessageCardModel(
                    message: "Message \(index + 1)",
                    isSender: index % 2 == 0,
                    image: nil,
                    timestamp: Date().addingTimeInterval(-Double(index * 60)) // Simulating timestamps
                )
            }
            NavigationLink(destination: ConversationView(title: "Jane Doe", messages: messages)) {
                Text("Go to Conversation")
            }
            
            Spacer()
        }
    }
}

