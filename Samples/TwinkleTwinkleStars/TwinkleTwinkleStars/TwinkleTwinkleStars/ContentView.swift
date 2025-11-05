//
//  ContentView.swift
//  TwinkleTwinkleStars
//
//  Created by victor amaro on 04/11/25.
//

import SwiftUI

struct ContentView: View {
    
    class Star: ObservableObject {
        var opacity: Double
        let initialOpacity: Double
        let freq: Double
        let width: CGFloat
        let height: CGFloat
        
        private(set) var x: CGFloat
        private(set) var y: CGFloat
        
        private var shouldTwinkle: Bool {
            let rnd = Double.random(in: 0.0...1.0)
            return rnd > 0.98
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
                let wave = sin(delta * freq) * initialOpacity
                self.opacity = wave
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
    
    @State
    var stars: [Star] = Star.create()
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                
                for star in stars {
                    
                    let rect = CGRect(
                        x: star.x,
                        y: star.y,
                        width: star.width,
                        height: star.height
                    )
                    
                    star.twinkle(time: timeline.date)
                    
                    let starPath = Path(ellipseIn: rect)
                    context.fill(starPath ,with: .color(.white.opacity(star.opacity)))
                     
                    
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
