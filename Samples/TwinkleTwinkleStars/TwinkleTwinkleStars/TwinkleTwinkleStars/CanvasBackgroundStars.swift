//
//  ContentView.swift
//  TwinkleTwinkleStars
//
//  Created by victor amaro on 04/11/25.
//

import SwiftUI

struct CanvasBackgroundStars: View {
    
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
    CanvasBackgroundStars()
        .preferredColorScheme(.dark)
}
