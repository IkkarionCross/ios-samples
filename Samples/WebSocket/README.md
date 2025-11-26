# WebSocket Example

## What is a WebSocket?

A **WebSocket** is a persistent, bidirectional connection between a server and a client. Unlike a normal HTTP request, which opens and closes a connection for each call, WebSockets are designed to stay open, enabling fast and continuous information flow.

### Example: Fetching messages from a backend chat service

~~~http
GET api.mychat.com/chat/{chat_id}/messages
~~~


In an iOS app, you’d typically model this request with URLSession. It handles opening the connection, performing the handshake, and closing it. However, that communication happens over HTTP — a protocol designed for fetching resources, not for continuous, real-time updates.

Now imagine building a real-time chat. You’d need to keep both client and server in sync within a reasonable time frame. While this can be done with polling, queues, or sync techniques, it adds complexity.

WebSockets simplify the problem: they keep the connection open, letting the server and client continuously exchange messages in real time.

This project demonstrates how to use Swift’s async/await and concurrency features to build a WebSocket client, modeled as if it were part of a chat app.


## The Socket

To initialize a WebSocket in Swift/iOS, you can use:

~~~Swift
URLSession(configuration: .default)
    .webSocketTask(with: URL(string: "wss://echo.websocket.org/")!)
~~~

> Note: echo.websocket.org is a public test server. It simply echoes back any message you send.

It’s good practice to isolate connection setup in a factory or core library. Here’s a simple example:

~~~Swift
public struct WebSocketSessionFactory: WebSocketSessionFactoryProtocol {
    public static func make() -> WebSocketSessionProtocol {
        URLSession(configuration: .default)
            .webSocketTask(with: URL(string: "wss://echo.websocket.org/")!)
    }
}

~~~

Notice the protocol WebSocketSessionProtocol. This abstraction makes testing easier, since Apple’s APIs often need to be mocked.

~~~Swift

public protocol WebSocketSessionProtocol: Sendable {
    @MainActor
    var closeCode: URLSessionWebSocketTask.CloseCode { get }
    
    func resume() async
    func send(_ message: URLSessionWebSocketTask.Message) async throws
    func receive() async throws -> URLSessionWebSocketTask.Message
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?)
}

extension URLSessionWebSocketTask: WebSocketSessionProtocol {}

~~~

## Codable Support

Since JSON is the most common format for exchanging data, we’ll use Codable to send and receive messages.

~~~Swift

internal protocol WebSocketCodableServiceProtocol: Sendable {
    associatedtype Receiving: Decodable & Sendable
    associatedtype Sending: Encodable & Sendable
    
    func connect() async throws
    func disconnect() async
    func sendMessage(_ message: Sending) async throws
    func receive() -> AsyncThrowingStream<Receiving, Error>
}

~~~

## Receiving Messages

The receive method returns an AsyncThrowingStream, which continuously waits for new messages:

~~~Swift
func receive() -> AsyncThrowingStream<Receiving, Error> {
    AsyncThrowingStream { [weak self] in
        guard let self else { return nil }
        
        if await self.webSocket?.closeCode != .invalid {
            return nil
        }

        let message = try await self.listenForMessages()
        return Task.isCancelled ? nil : message
    }
}
~~~

The helper listenForMessages decodes messages and delegates to the WebSocket API:

~~~Swift
func listenForMessages() async throws -> Receiving {
    guard let message = try await webSocket?.receive() else {
        throw NSError(domain: "WebSocket may be nil", code: -1)
    }
    
    switch message {
    case .string(let text):
        return text as? Receiving ?? Receiving.self as! Receiving
    case .data(let data):
        return try decoder.decode(Receiving.self, from: data)
    @unknown default:
        await webSocket?.cancel(with: .unsupportedData, reason: nil)
        throw NSError(domain: "Unknown message type", code: -1)
    }
}
~~~
Here, any unexpected message cancels the WebSocket and throws an error.

## Sending Messages

Sending is straightforward:

~~~Swift`
func sendMessage(_ message: Sending) async throws {
    let encodedMessage = try encoder.encode(message)
    let wsMessage = URLSessionWebSocketTask.Message.data(encodedMessage)
    try await self.webSocket?.send(wsMessage)
}
~~~

## Ping–Pong (Keep-Alive)

WebSockets require periodic ping–pong messages to keep connections alive:

~~~Swift
self.timer = Timer.scheduledTimer(
    timeInterval: 3.0,
    target: self,
    selector: #selector(sendPing),
    userInfo: nil,
    repeats: true
)

@objc
private func sendPing() async {
    await webSocket?.sendPing { error in
        Task { @MainActor [weak self, error] in
            guard let error else { return }
            
            self?.disconnect(withCloseCode: .internalServerError)
            self?.onPingFailed?(error)
        }
    }
}
~~~

### Concurrency Considerations

Where does this code run — main thread or background?

Notice the use of `@MainActor``. For example, in our service:

~~~Swift
public final class WebSocketCodableService<
    Sending: Encodable & Sendable,
    Receiving: Decodable & Sendable
>: WebSocketCodableServiceProtocol, Sendable {
    
    @MainActor
    private var webSocket: WebSocketSessionProtocol?
    
    private let connectionFactory: WebSocketSessionFactoryProtocol.Type
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    @MainActor
    private var timer: Timer?
    
    @MainActor
    internal var onPingFailed: (@MainActor @Sendable (Error?) -> Void)?
    
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
}
~~~

- webSocket must be isolated to the MainActor because the service is Sendable, and mutable state must be actor-isolated.

- As a result, connect() and disconnect() also run on the MainActor.

- Other operations (sending, receiving, decoding) run in the background, preventing UI blocking.


## Example: Synchronizing back to MainActor

Here, we explicitly hop back to the MainActor because both disconnect and onPingFailed are MainActor-isolated.

~~~Swift
@objc
private func sendPing() async {
    await webSocket?.sendPing { error in
        Task { @MainActor [weak self, error] in
            guard let error else { return }
            
            self?.disconnect(withCloseCode: .internalServerError)
            self?.onPingFailed?(error)
        }
    }
}
~~~
