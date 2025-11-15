//
//  HttpClientMock.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 12/10/25.
//

import Foundation
@testable import SwiftUINavigation

@MainActor
final class HttpClientMock: HttpClientProtocol {
    
    var response: Decodable?
    var error: Error?
    var requestCalled = false
    var givenRequest: URLRequest?
    
    func request<T: Decodable>(
        request: URLRequest
    ) async throws -> T {
        requestCalled = true
        givenRequest = request
        
        if let error = error {
            throw error
        }
        
        guard let response = response as? T else {
            throw URLError(.badServerResponse)
        }
        
        return response
    }
    
}
