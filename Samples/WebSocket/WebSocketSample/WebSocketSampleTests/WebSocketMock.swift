//
//  WebSocketMock.swift
//  ComponentLab
//
//  Created by victor amaro on 28/08/25.
//

import Foundation
@testable import WebSocketSample

@MainActor
internal final class WebSocketMock: WebSocketSessionProtocol {
    
    private(set) var closeCode: URLSessionWebSocketTask.CloseCode
    
    private(set) var resumeCalled: Bool
    private(set) var sendCalled: Bool
    private(set) var receiveCalled: Bool
    private(set) var cancelCalled: Bool
    private(set) var lastSentMessage: URLSessionWebSocketTask.Message?
    
    var error: Error?
    var message: URLSessionWebSocketTask.Message
    
    init() {
        self.resumeCalled = false
        self.sendCalled = false
        self.receiveCalled = false
        self.cancelCalled = false
        self.error = nil
        self.message = .string("Test message")
        self.closeCode = .invalid
    }
    
    func resume() async {
        resumeCalled = true
    }
    
    func send(_ message: URLSessionWebSocketTask.Message) async throws {
        sendCalled = true
        lastSentMessage = message
        
        if let error {
            throw error
        }
    }
    
    func receive() async throws -> URLSessionWebSocketTask.Message {
        receiveCalled = true
        
        if let error {
            throw error
        }
        
        return message
    }
    
    @preconcurrency
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        cancelCalled = true
        self.closeCode = closeCode
    }
    
}


@MainActor
internal final class WebSocketFactorySessionMock: @preconcurrency WebSocketSessionFactoryProtocol {
    
    static var webSocketMock: WebSocketMock = WebSocketMock()
    
    static func make() -> sending WebSocketSessionProtocol {
        
        return webSocketMock
    }
}
