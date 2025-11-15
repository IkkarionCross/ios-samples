//
//  ConsumeResponse.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 12/10/25.
//

@testable import SwiftUINavigation

extension ConsumeResponse {
    
    static func dummy() -> ConsumeResponse {
        return ConsumeResponse(
                url: "https://www.example.com"
            )
    }
    
    static func dummy(withOriginalUrl url: String) -> ConsumeResponse {
        return ConsumeResponse(
                url: url
            )
    }
        
}
