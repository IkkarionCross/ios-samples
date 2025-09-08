//
//  MessageListView.swift
//  ComponentLab
//
//  Created by victor amaro on 30/07/25.
//

import SwiftUI

public struct MessagesListView: View {
    
    private let messages: [MessageCardModel]

    init(messages: [MessageCardModel]) {
        self.messages = messages
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            LazyVStack {
                ForEach(messages, id: \.self) { message in
                    HStack {
                        if message.isSender {
                            Spacer()
                        }
                        
                        MessageCardView(model: message)
                        
                        if !message.isSender {
                            Spacer()
                        }
                            
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.clear)
                    .cornerRadius(15)
                    .id(message)
                }
            }
        }
    }
}
