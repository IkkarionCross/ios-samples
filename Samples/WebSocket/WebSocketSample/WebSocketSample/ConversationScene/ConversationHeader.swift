//
//  ConversationHeader.swift
//  ComponentLab
//
//  Created by victor amaro on 20/07/25.
//

import SwiftUI

public struct ConversationHeader: View {
    
    private let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                ProfileCardView(
                    profileImageSize: 40,
                    profileDescriptionSpacing: 0,
                    profileImageSpacing: 5,
                    padding: 0,
                    shadowRadius: 0
                )
                HStack(spacing: 10) {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Image(systemName: "phone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                    
            }
        }
        .padding()
        .background(Color.white)
        .navigationTitle(self.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Action for settings button
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Action for settings button
                }) {
                    Image(systemName: "phone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    // Action for settings button
                }) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 20)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
