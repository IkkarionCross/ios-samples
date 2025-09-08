//
//  ProfileCarVieew.swift
//  ComponentLab
//
//  Created by victor amaro on 20/07/25.
//

import SwiftUI

public struct ProfileCardView: View {
    
    private let profileImageSize: CGFloat
    private let profileImageSpacing: CGFloat
    private let profileDescriptionSpacing: CGFloat
    private let padding: CGFloat
    private let shadowRadius: CGFloat
    
    public init(
        profileImageSize: CGFloat = 50,
        profileDescriptionSpacing: CGFloat = 10,
        profileImageSpacing: CGFloat = 10,
        padding: CGFloat = 16,
        shadowRadius: CGFloat = 5
    ) {
        self.profileImageSize = profileImageSize
        self.profileImageSpacing = profileImageSpacing
        self.profileDescriptionSpacing = profileDescriptionSpacing
        self.padding = padding
        self.shadowRadius = shadowRadius
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: profileImageSize, height: profileImageSize)
                .foregroundColor(.blue)
                .padding(.trailing, profileImageSpacing)
        
            VStack(
                alignment: .leading,
                spacing: profileDescriptionSpacing
            ) {
                Text("Profile Card")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("This is a simple profile card view.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
            }
        }
        .padding(padding)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: shadowRadius)
    }
}


#Preview {
    ProfileCardView()
}
