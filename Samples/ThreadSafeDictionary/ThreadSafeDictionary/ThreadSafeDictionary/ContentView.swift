//
//  ContentView.swift
//  ThreadSafeDictionary
//
//  Created by victor amaro on 09/09/25.
//

import SwiftUI

struct ContentView: View {
    let notSafeDict = NotThreadSafeKeyValueStore()
    
    var body: some View {
        VStack {
            Button("Break Dictionary") {
                DispatchQueue.concurrentPerform(iterations: 20) { index in
                    Task.detached {
                        await notSafeDict.setValue("Value \(index)", forKey: "Key \(index)")
                        await notSafeDict.printAll()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
