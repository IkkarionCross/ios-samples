//
//  String+ValidUrlTests.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 12/10/25.
//

import Testing
import Foundation
@testable import SwiftUINavigation

@MainActor
struct String_ValidUrlTests {
    
    @Test
    func shouldBeValidUrl() {
        let urlString = "https://www.example.com"
        
        #expect(urlString.isValidURL() == true)
    }
    
    @Test
    func shouldBeValidUrl_WithoutW3() {
        let urlString = "https://example.com"
        
        #expect(urlString.isValidURL() == true)
    }
    
    @Test
    func shouldBeValidUrl_AnotherCountry() {
        let urlString = "https://www.example.com.br"
        
        #expect(urlString.isValidURL() == true)
    }
    
    @Test
    func shouldNOTBeValidUrl_Typo() {
        let urlString = "https://ww.example.com"
        
        #expect(urlString.isValidURL() == false)
    }
    
    @Test
    func shouldNOTBeValidUrl_MissingProtocol() {
        let urlString = "ht://www.example.com"
        
        #expect(urlString.isValidURL() == false)
    }
    
    @Test
    func shouldNOTBeValidUrl_MissingCharacterDefinition() {
        let urlString = "https:www.example.com"
        
        #expect(urlString.isValidURL() == false)
    }
    
    @Test
    func shouldNOTBeValidUrl_MissingCharacterDotCom() {
        let urlString = "https://www.example"
        
        #expect(urlString.isValidURL() == false)
    }
    
}

