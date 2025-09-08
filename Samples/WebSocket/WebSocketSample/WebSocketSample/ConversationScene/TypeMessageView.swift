//
//  TypeMessageView.swift
//  ComponentLab
//
//  Created by victor amaro on 30/07/25.
//

import SwiftUI

public struct TypeMessageView: View {
    
    @State private var messageText: String = ""
    private let service: WebSocketCodableService<String, String>
    private var onSend: ((String) -> Void)
    
    public init(service: WebSocketCodableService<String, String>, onSend: @escaping ((String) -> Void)) {
        self.service = service
        self.onSend = onSend
    }
    
    public var body: some View {
        HStack {
            TextField(
                "Type a message...",
                text: $messageText,
                axis: .vertical
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 10)
                .animation(.default, value: messageText)
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                Button(action: disconnect) {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.red)
                }
            }
            .disabled(messageText.isEmpty)
        }
        .padding()
    }
    
    private func sendMessage() {
        print("Message sent: \(messageText)")
        Task {
            do {
                try await service.sendMessage(messageText)
            } catch {
                print(error)
            }
            onSend(messageText)
            messageText = String()
        }
        
    }
    
    private func disconnect() {
        Task {
            await service.disconnect()
            print("Disconnected from the chat service")
        }
    }
}

