//
//  WebSocketDecodableService.swift
//  ComponentLab
//
//  Created by victor amaro on 25/08/25.
//

import Foundation
import Testing

@testable import WebSocketSample

@MainActor
struct WebSocketCodableServiceTests {
    
    let webSocketService: WebSocketCodableService<String, String>
    var webSocketMock: WebSocketMock
    
    init() {
        WebSocketFactorySessionMock.webSocketMock = WebSocketMock()
        webSocketMock = WebSocketFactorySessionMock.webSocketMock
        self.webSocketService = WebSocketCodableService<String, String>(
            connectionFactory: WebSocketFactorySessionMock.self,
            webSocket: webSocketMock
        )
    }
    
    @Test
    func shouldConnectAndDisconnect() async throws {
        try await webSocketService.connect()
        #expect(webSocketMock.resumeCalled == true)
        webSocketService.disconnect()
        #expect(webSocketMock.cancelCalled == true)
        #expect(webSocketMock.closeCode == .normalClosure)
    }
    
    @Test
    func shouldSendMessage() async throws {
        try await webSocketService.connect()
        
        let messageToSend = "Hello, WebSocket!"
        
        try await webSocketService.sendMessage(messageToSend)
        
        #expect(webSocketMock.sendCalled == true)
        let lastSentMessage = try #require(webSocketMock.lastSentMessage)
        switch lastSentMessage {
            
        case .data(let data):
            #expect(String(data: data, encoding: .utf8) == "\"\(messageToSend)\"")
        case .string(let text):
            #expect(Bool(false), "Expected a data message, but got string: \(text)")
        @unknown default:
            #expect(Bool(false), "Expected a string message, but got unknown type")
        }
        
    }
    
    @Test
    func shouldNotSendMessageServerError() async throws {
        let expectedError = URLError(.notConnectedToInternet)
        webSocketMock.error = expectedError
        
        try await webSocketService.connect()
        
        let messageToSend = "Hello, WebSocket!"
        
        await #expect(throws: expectedError, "Should receive error \(expectedError.localizedDescription)" ) {
            try await webSocketService.sendMessage(messageToSend)
        }
        
        #expect(webSocketMock.sendCalled == true)
    }
    
    @Test
    func shouldReceiveMessages() async throws {
        webSocketMock.message = .string("Hello, World!")
        
        try await webSocketService.connect()
        
        for try await message in webSocketService.receive() {
            #expect(message == "Hello, World!")
            webSocketService.disconnect()
        }
        
    }
    
    @Test
    func shouldNotReceiveMessagesWhenDisconnected() async throws {
        webSocketMock.message = .string("Hello, World!")
        
        try await webSocketService.connect()
        webSocketService.disconnect()
        
        for try await _ in webSocketService.receive() {
            #expect(Bool(false), "Should not receive messages when disconnected")
        }
        
        #expect(true, "No messages received as expected")
    }
    
    @Test
    func shouldNotReceiveMessagesWhenTaskCancelled() async throws {
        webSocketMock.message = .string("Hello, World!")
        
        try await webSocketService.connect()
        let task = Task { @MainActor in
            for try await _ in webSocketService.receive() {
                #expect(Bool(false), "Should not receive messages when task is cancelled")
            }
        }
        
        task.cancel()
        
        #expect(true, "No messages received as expected")
    }
    
    @Test
    func shouldNotReceiveMessagesWhenServerError() async throws {
        let expectedError = URLError(.notConnectedToInternet)
        webSocketMock.error = expectedError
        
        try await webSocketService.connect()
        
        await #expect(throws: expectedError, "Should receive error \(expectedError.localizedDescription)" ) {
            for try await _ in webSocketService.receive() {
                #expect(Bool(false), "Should not receive messages when disconnected")
            }
        }
        
    }
    
}

