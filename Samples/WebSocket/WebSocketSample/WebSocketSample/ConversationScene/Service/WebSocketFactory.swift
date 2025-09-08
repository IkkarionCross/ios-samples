//
//  WebSocketFactory.swift
//  ComponentLab
//
//  Created by victor amaro on 29/08/25.
//

import Foundation

public protocol WebSocketSessionFactoryProtocol {
    static func make() -> WebSocketSessionProtocol
}

public struct WebSocketSessionFactory: WebSocketSessionFactoryProtocol {
    
    public static func make() -> WebSocketSessionProtocol {
        return URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://echo.websocket.org/")!)
    }
    
}
