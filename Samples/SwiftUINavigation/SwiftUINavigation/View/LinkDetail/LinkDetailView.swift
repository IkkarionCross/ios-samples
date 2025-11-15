//
//  LinkDetailView.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 13/10/25.
//

import SwiftUI

struct LinkDetailView: View {
    
    private var shortLink: String
    
    init(shortLink: String) {
        self.shortLink = shortLink
    }
    
    var body: some View {
        Text("\(shortLink)")
    }
}
