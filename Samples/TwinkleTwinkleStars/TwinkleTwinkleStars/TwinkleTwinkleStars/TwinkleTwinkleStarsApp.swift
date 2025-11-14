//
//  TwinkleTwinkleStarsApp.swift
//  TwinkleTwinkleStars
//
//  Created by victor amaro on 04/11/25.
//

import SwiftUI

@main
struct TwinkleTwinkleStarsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack{
                    NavigationLink(destination: CanvasBackgroundStars()) {
                        Text("Canvas Background Stars")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: CircleViewBackgroundStars()) {
                        Text("Circle Background Stars")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: ShaderBackgroundStars()) {
                        Text("Shader Background Stars")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
            }
                .preferredColorScheme(.dark)
        }
    }
}
