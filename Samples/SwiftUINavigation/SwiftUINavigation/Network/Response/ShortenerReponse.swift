//
//  Reponse.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 10/10/25.
//

import Foundation

internal struct ShortenerReponse: Decodable, Sendable {
    let alias: String
    let links: LinkProperties
    
    enum CodingKeys: String, CodingKey {
        case alias = "alias"
        case links = "_links"
    }
}

internal struct LinkProperties: Decodable, Sendable {
    let originalUrl: String
    let short: String
    
    init(short: String, originalUrl: String) {
        self.short = short
        self.originalUrl = originalUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case originalUrl = "self"
        case short = "short"
    }
        
}
