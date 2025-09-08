//
//  WebSocketSampleApp.swift
//  WebSocketSample
//
//  Created by victor amaro on 01/09/25.
//

import SwiftUI

@main
struct WebSocketSampleApp: App {
    @State
    private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    NavigationLink(destination: ConversationView(title: "Jane Doe", messages: messagesMock())) {
                        Text("Conversation Demo")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .navigationTitle("Home")
            }
        }
        .environmentObject(networkMonitor)
    }
    
    func messagesMock() -> [MessageCardModel] {
        let baseDate = Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()

        return (0..<100).map { index in
            let timeOffset = TimeInterval(index * 120)
            let messageDate = baseDate.addingTimeInterval(timeOffset)

            let messages: [(String, Bool)] = [
                ("Hey! How's it going?", true),
                ("Hi! I'm doing great, just got back from an amazing trip to Japan. The cherry blossoms were in full bloom and the streets of Kyoto were absolutely magical. We visited so many temples and tried incredible food!", false),
                ("That sounds incredible! I've always wanted to visit Japan", true),
                ("You definitely should! The culture and history are fascinating", false),
                ("Can you recommend some places to visit?", true),
                ("I'd definitely recommend spending at least a week exploring Tokyo and Kyoto. Make sure to visit the Fushimi Inari Shrine with its thousands of red torii gates, and don't miss the Tsukiji Outer Market for the freshest sushi you'll ever taste. The bullet train system makes it super easy to travel between cities, and everyone is incredibly helpful even if you don't speak Japanese.", false),
                ("Thanks for all the tips!", true),
                ("When are you planning to go?", false),
                ("Maybe next spring", true),
                ("Perfect time for cherry blossoms", false),
                ("I should start saving up", true),
                ("Let me know if you need more advice", false),
                ("Will do! Thanks again", true),
                ("No problem at all!", false),
                ("Time to start learning some Japanese", true)
            ]

            let messageIndex = index % messages.count
            return MessageCardModel(
                message: messages[messageIndex].0,
                isSender: messages[messageIndex].1,
                image: nil,
                timestamp: messageDate
            )
        }
    }

}
