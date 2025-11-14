//
//  Star.swift
//  TwinkleTwinkleStars
//
//  Created by victor amaro on 14/11/25.
//

import Foundation
import SwiftUI

class Star: ObservableObject, Identifiable, Hashable {
    
    static func == (lhs: Star, rhs: Star) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(initialOpacity)
        hasher.combine(id)

    }
    
    @Published
    var opacity: Double
    let initialOpacity: Double
    let freq: Double
    let width: CGFloat
    let height: CGFloat
    
    private(set) var x: CGFloat
    private(set) var y: CGFloat
    
    private var shouldTwinkle: Bool {
        return Double.random(in: 0.0...1.0)  > 0.98
    }
    
    private static var lastDate: Date? = nil
    
    init() {
        self.initialOpacity = Double.random(in: 0.0...1.0)
        self.opacity = initialOpacity
        self.freq = Double.random(in: 0.1...1.0)
        self.x = CGFloat.random(in: 0.0...UIScreen.main.bounds.width)
        self.y = CGFloat.random(in: 0.0...UIScreen.main.bounds.height)
        self.width = CGFloat.random(in: 1.0...4.0)
        self.height = CGFloat.random(in: 1.0...4.0)
    }
    
    func twinkle(time: Date) {
        if Star.lastDate == nil {
            Star.lastDate = time
        }
        
        let delta =  Star.lastDate!.distance(to: Date())
        
        if shouldTwinkle {
            self.opacity = sin(delta * freq) * initialOpacity
        }
        
    }
    
    static func create() -> [Star] {
        var stars: [Star] = []
        
        for _ in 0..<200 {
            stars.append(Star())
        }
        
        return stars
    }
    
    
}
