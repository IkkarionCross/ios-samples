//
//  ShortenerServiceMock.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 12/10/25.
//

import Foundation
@testable import SwiftUINavigation

final class ShortenerServiceMock: ShortenerServiceProtocol {
    
    var shortenResponse: ShortenerReponse = ShortenerReponse.dummy()
    var shortenError: Error?
    var shortenURLCalled = false
    
    var consumeResponse: ConsumeResponse = ConsumeResponse.dummy()
    var consumeError: Error?
    var consumeURLCalled = false
    
    internal func shorten(url: String) async throws -> ShortenerReponse {
        shortenURLCalled = true
        
        if let error = shortenError {
            throw error
        }
        
        return shortenResponse
    }
    
    func consume(consumerId: String) async throws -> ConsumeResponse {
        
        consumeURLCalled = true
        
        if let error = consumeError {
            throw error
        }
        
        return consumeResponse
    }
}
