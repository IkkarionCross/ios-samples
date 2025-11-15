//
//  ShortenerReponse.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 12/10/25.
//

import Foundation
@testable import SwiftUINavigation

extension ShortenerReponse {
    
    static func dummy() -> ShortenerReponse {
        return ShortenerReponse(
            alias: "abc123",
            links: LinkProperties(
                short: "https://shrtco.de/abc123",
                originalUrl: "https://api.shrtco.de/v2/shorten?url=example.org/very/long/link.html"
            )
        )
    }
    
    static func dummy(withOriginalUrl url: String) -> ShortenerReponse {
        return ShortenerReponse(
            alias: "abc123",
            links: LinkProperties(
                short: "https://shrtco.de/abc123",
                originalUrl: "url"
            )
        )
    }
}
