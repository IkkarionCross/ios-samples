//
//  ShortenerService.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 10/10/25.
//

import Foundation

protocol ShortenerServiceProtocol: Sendable {
    
    func shorten(url: String) async throws -> ShortenerReponse
    func consume(consumerId: String) async throws -> ConsumeResponse
    
}

final internal class ShortenerService: ObservableObject {
    private let httpClient: HttpClientProtocol
    
    internal init(httpClient: HttpClientProtocol = HttpClient.init()) {
        self.httpClient = httpClient
    }
    
    internal func shorten(url: String) async throws -> ShortenerReponse {
        
        let api = URLShortenerAPI.shortenURL(originalURL: url)
        
        return try await httpClient.request(request: api.toURLRequest())
    }
    
    internal func consume(consumerId: String) async throws -> ConsumeResponse {
        
        let api = URLShortenerAPI.getShortenedURL(consumerId: consumerId)
        
        return try await httpClient.request(request: api.toURLRequest())
    }
}

extension ShortenerService: ShortenerServiceProtocol {}
