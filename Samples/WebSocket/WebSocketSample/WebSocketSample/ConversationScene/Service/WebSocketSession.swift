//
//  WebSocketSessionFacade.swift
//  ComponentLab
//
//  Created by victor amaro on 25/08/25.
//

import Foundation

public protocol WebSocketSessionProtocol: Sendable {
    
    @MainActor
    var closeCode: URLSessionWebSocketTask.CloseCode { get }
    
    func resume() async
    func send(_ message: URLSessionWebSocketTask.Message) async throws
    func sendPing(pongReceiveHandler: @escaping @Sendable ((any Error)?) -> Void)
    func receive() async throws -> URLSessionWebSocketTask.Message
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?)
    
}

extension URLSessionWebSocketTask: WebSocketSessionProtocol { }
