//
//  ThreadSafeDictionary.swift
//  ThreadSafeDictionary
//
//  Created by victor amaro on 09/09/25.
//

import Foundation

class NotThreadSafeKeyValueStore {
    
    private var dict: [String: String] = [:]
    
    private var lock: NSLock = NSLock()
    
    func setValue(_ value: String, forKey key: String) {
        defer { lock.unlock() }
        lock.lock()
        dict[key] = value
    }
    
    func getValue(forKey key: String) -> String? {
        return dict[key]
    }
    
    func printAll() {
        defer { lock.unlock() }
        lock.lock()
        for (key, value) in dict {
            print("\(key): \(value)")
        }
    }
    
}
