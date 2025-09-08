//
//  MessageCardView.swift
//  ComponentLab
//
//  Created by victor amaro on 20/07/25.
//

import SwiftUI

public class MessageCardModel: Hashable, Identifiable {
    public static func == (lhs: MessageCardModel, rhs: MessageCardModel) -> Bool {
        lhs.id == rhs.id
    }
    
    
    public var id: UUID = UUID()
    
    let message: String
    let isSender: Bool
    let image: Image?
    let timestamp: Date
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    init(message: String, isSender: Bool, image: Image?, timestamp: Date) {
        self.message = message
        self.isSender = isSender
        self.image = image
        self.timestamp = timestamp
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct MessageCardView: View {
    
    private let model: MessageCardModel
    
    public init(model: MessageCardModel) {
        self.model = model
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {

            if let image = model.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(8)
            }
            HStack {
                Text(model.message)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .fontWeight(.medium)
                VStack {
                    Spacer()
                    Text(model.formattedTimestamp)
                        .font(.system(size: 11))
                        .fontWeight(.regular)
                }
            }
            .padding(12)
            
        }
        .background(
            model.isSender ? Color.green.gradient :  Color.blue.gradient
        )
        .frame(minWidth: 150, minHeight: 50, maxHeight: 300)
        .cornerRadius(12)
//        .padding(16)
//        .background(Color.white)
    }
}

#Preview {
    MessageCardView(
        model:
            MessageCardModel(
                message: "Oi!",
                isSender: true,
                image: nil,
                timestamp: Date()
            )
    )
}
