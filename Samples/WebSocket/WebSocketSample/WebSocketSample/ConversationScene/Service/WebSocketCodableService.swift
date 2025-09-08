//
//  ChatService.swift
//  ComponentLab
//
//  Created by victor amaro on 23/07/25.
//

import Foundation
import Network
import NetworkExtension

internal protocol WebSocketCodableServiceProtocol: Sendable {
    associatedtype Receiving : Decodable & Sendable
    associatedtype Sending : Encodable & Sendable
    
    func connect() async throws
    func disconnect() async
    func sendMessage(_ message: Sending) async throws
}

public final class WebSocketCodableService<Sending: Encodable & Sendable, Receiving: Decodable & Sendable>: WebSocketCodableServiceProtocol, Sendable {
    typealias Sending = Sending
    typealias Receiving = Receiving
    
    @MainActor
    private var webSocket: WebSocketSessionProtocol?
    private let connectionFactory: WebSocketSessionFactoryProtocol.Type
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    @MainActor
    private var timer: Timer?
    
    @MainActor
    internal var onPingFailed: (@MainActor @Sendable (_: Error?) -> Void)?
    
    @MainActor
    public init(
        connectionFactory: WebSocketSessionFactoryProtocol.Type = WebSocketSessionFactory.self,
        webSocket: sending WebSocketSessionProtocol? = nil,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder(),
        onPingFailed: (@MainActor @Sendable (_: Error?) -> Void)? = nil
    ) {
        self.webSocket = webSocket
        self.connectionFactory = connectionFactory
        self.encoder = encoder
        self.decoder = decoder
        self.timer = Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(sendPing),
            userInfo: nil,
            repeats: true
        )
        self.onPingFailed = onPingFailed
    }
    
    @MainActor
    public func connect() async throws {
        webSocket = connectionFactory.make()
        await webSocket?.resume()
    }
    
    @MainActor
    public func disconnect() {
        webSocket?.cancel(with: .normalClosure, reason: nil)
        timer?.invalidate()
    }
    
    public func sendMessage(_ message: Sending) async throws  {
        let encodedMessage = try encoder.encode(message)
        let message = URLSessionWebSocketTask.Message.data(encodedMessage)
        try await self.webSocket?.send(message)
    }
    
    internal func receive() -> AsyncThrowingStream<Receiving, Error> {
        AsyncThrowingStream { [weak self] in
            guard let self else {
                return nil
            }
            
            if await self.webSocket?.closeCode != .invalid {
                return nil
            }

            let message = try await self.listenForMessages()

            return Task.isCancelled ? nil : message
        }
    }
    
    @MainActor
    private func disconnect(withCloseCode code: URLSessionWebSocketTask.CloseCode) {
        webSocket?.cancel(with: code, reason: nil)
        timer?.invalidate()
    }
    
    private func listenForMessages() async throws -> Receiving {
        guard let message = try await webSocket?.receive() else {
            throw NSError(domain: "WebSocket maybe nil", code: -1, userInfo: nil)
        }
        switch message {
        case .string(let text):
            return text as? Receiving ?? Receiving.self as! Receiving
        case .data(let data):
            let decoded = try decoder.decode(Receiving.self, from: data)
            return decoded
            
        @unknown default:
            await disconnect(withCloseCode: .unsupportedData)
            throw NSError(domain: "Unknown message type", code: -1, userInfo: nil)
        }
        
    }
    
    @objc
    private func sendPing() async {
        await webSocket?.sendPing { error in
            Task { @MainActor [weak self, error] in
                guard let error else {
                    return
                }
                
                self?.disconnect(withCloseCode: .internalServerError)
                self?.onPingFailed?(error)
            }
        }
    }
    
}
