//
//  ShaderBackgroundStars.swift
//  TwinkleTwinkleStars
//
//  Created by victor amaro on 11/11/25.
//

import SwiftUI

struct ShaderBackgroundStars: View {
    let startDate: Date = Date()
    
    
    var body: some View {
        GeometryReader { proxy in
            TimelineView(.animation) { context in
                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .stroke(Color.black)
                        .colorEffect(
                            ShaderLibrary.starfieldShader(.float(startDate.timeIntervalSinceNow))
                        )
                }
            }
        }
    }
}
