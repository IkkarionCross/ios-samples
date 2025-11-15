//
//  Item.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 10/10/25.
//

import Foundation
import SwiftData

@Model
final class SavedLink {
    var timestamp: Date
    var originalURL: String
    var shortURL: String?
    var id: UUID = UUID()
    var name: String?
    var consumerId: String?
    
    init(timestamp: Date, originalURL: String, shortURL: String? = nil) {
        self.timestamp = timestamp
        self.originalURL = originalURL
        self.shortURL = shortURL
    }
}
