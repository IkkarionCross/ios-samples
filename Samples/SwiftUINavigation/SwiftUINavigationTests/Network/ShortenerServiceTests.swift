//
//  HttpClientMock.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 12/10/25.
//

import Testing
import Foundation
@testable import SwiftUINavigation

@MainActor
final class ShortenerServiceTests  {
    
    var httpClientMock: HttpClientMock!
    var sut: ShortenerService!
    
    init() {
        httpClientMock = HttpClientMock()
        sut = ShortenerService(httpClient: httpClientMock)
        
    }
    
    @Test
    func shouldShortenUrl() async throws {
        let url = "https://www.example.com"
        let expectedRequest = try URLShortenerAPI.shortenURL(originalURL: url).toURLRequest()
        
        httpClientMock.response = ShortenerReponse.dummy(withOriginalUrl: url)
        
        let _ = try await sut.shorten(url: url)
        
        #expect(httpClientMock.requestCalled == true)
        #expect(httpClientMock.givenRequest?.url?.absoluteString == expectedRequest.url?.absoluteString)
        
    }
    
    @Test
    func shouldConsumeURL() async throws {
        let consumerId = "123abc"
        let expectedRequest = try URLShortenerAPI.getShortenedURL(consumerId: consumerId).toURLRequest()
        
        httpClientMock.response = ConsumeResponse.dummy(withOriginalUrl: "https://www.example.com")
        
        let _ = try await sut.consume(consumerId: consumerId)
        
        #expect(httpClientMock.requestCalled == true)
        #expect(httpClientMock.givenRequest?.url?.absoluteString == expectedRequest.url?.absoluteString)
        
    }
    
}

