//
//  URLShortenerAPI.swift
//  SwiftUINavigation
//
//  Created by victor amaro on 10/10/25.
//

import Foundation

internal enum URLShortenerAPI {
    static let baseURL = URL(string: "https://url-shortener-server.onrender.com/api/alias")!
    
    case shortenURL(originalURL: String)
    case getShortenedURL(consumerId: String)
    
    var parameters: [String: Any] {
        switch self {
        case .shortenURL(originalURL: let originalURL):
            return ["url": originalURL]
        case .getShortenedURL(consumerId: let consumerId):
            return ["consumer_id": consumerId]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .shortenURL:
            return .post
        case .getShortenedURL:
            return .get
        }
    }
    
    func toURLRequest() throws -> URLRequest {
        
        var urlRequest = URLRequest(url: URLShortenerAPI.baseURL)
        urlRequest.httpMethod = method.rawValue
        switch method {
        case .post:
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(ShortenerRequestBody(url: parameters["url"] as? String ?? ""))
        case .get:
            var components = URLComponents(url: URLShortenerAPI.baseURL, resolvingAgainstBaseURL: false)!
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            urlRequest.url = components.url
        }
        urlRequest.httpBody = try JSONEncoder().encode(ShortenerRequestBody(url: parameters["url"] as? String ?? ""))
        
        return urlRequest
    }
}
