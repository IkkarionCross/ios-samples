//
//  SavedLink.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 13/10/25.
//

import Foundation
@testable import SwiftUINavigation

extension SavedLink {
    
    static func dummy() -> SavedLink {
        return SavedLink(
            timestamp: Date(),
            originalURL: "https://www.google.com",
            shortURL: "https://www.shortener/alias/abc123"
        )
    }
    
}
