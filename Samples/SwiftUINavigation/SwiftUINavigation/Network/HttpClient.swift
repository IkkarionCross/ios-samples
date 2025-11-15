//
//  HttpClient.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 10/10/25.
//
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol HttpClientProtocol: Sendable {
    func request<T: Decodable>(request: URLRequest) async throws -> T
}

final internal class HttpClient: HttpClientProtocol {
    
    enum HttpError: LocalizedError {
        case notFound
        case badRequest
        case internalServerError
        
        var errorDescription: String? {
            switch self {
            case .notFound:
                return "The requested resource was not found."
            case .badRequest:
                return "The request was invalid or cannot be served."
            case .internalServerError:
                return "An internal server error occurred."
            }
        }
    }
    
    let session: URLSession = .shared
    
    internal init() { }
    
    func request<T: Decodable>(
        request: URLRequest
    ) async throws -> T {
        
        let result = try await session.data(for: request)
        let data = result.0
        let urlResponse = result.1
        
        switch (urlResponse as? HTTPURLResponse)?.statusCode {
        case 400:
            throw HttpError.badRequest
            
        case 404:
            throw HttpError.notFound
            
        case 200:
            return try JSONDecoder().decode(T.self, from: data)
            
        default:
            throw HttpError.internalServerError
        }
        
    }

}
