//
//  CircleViewBackgroundStars.swift
//  TwinkleTwinkleStars
//
//  Created by victor amaro on 10/11/25.
//

import SwiftUI

class StarsViewModel: ObservableObject {
    @Published
    var stars: [ContentView.Star] = ContentView.Star.create()
}

struct CircleViewBackgroundStars: View {
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State
    var opacity: [Double] = Array(repeating: Double.random(in: 0.0...1.0), count: 200)
    
    @ObservedObject
    var viewModel: StarsViewModel = StarsViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0..<200) { i in
                    Circle()
                        .fill(Color.white)
                        .frame(width: viewModel.stars[i].width, height: viewModel.stars[i].height)
                        .position(x: viewModel.stars[i].x, y: viewModel.stars[i].y)
                        .opacity(opacity[i])
                        .onReceive(timer, perform: { ti in
                            
                            withAnimation(Animation.spring(duration: Double.random(in: 0.5...1.1))) {
                                opacity[i] = 0.1 + sin(ti.timeIntervalSince1970 * viewModel.stars[i].freq) * viewModel.stars[i].initialOpacity
                                
                            }
                            
                            
                        })
                }
            }
        }
    }
    
    private func randomRadius() -> CGSize {
        let radius = CGFloat.random(in: 1...3)
        
        return CGSize(width: radius, height: radius)
    }
    
    private func randomx(in proxy: GeometryProxy) -> CGFloat {
        return CGFloat.random(in: 0...proxy.size.width)
    }
    
    private func randomY(in proxy: GeometryProxy) -> CGFloat {
        return CGFloat.random(in: 0...proxy.size.height)
    }
    
}

#Preview {
    CircleViewBackgroundStars()
        .preferredColorScheme(.dark)
}
