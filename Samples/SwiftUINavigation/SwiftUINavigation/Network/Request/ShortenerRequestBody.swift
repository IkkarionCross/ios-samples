//
//  ShortenerRequestBody.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 10/10/25.
//

import Foundation

final internal class ShortenerRequestBody: Codable {
    let url: String
    
    init(url: String) {
        self.url = url
    }
}
