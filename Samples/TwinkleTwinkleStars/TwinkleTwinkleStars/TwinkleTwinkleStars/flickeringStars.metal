//
//  flickeringStars.metal
//  TwinkleTwinkleStars
//
//  Created by victor amaro on 11/11/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

#define M_PI 3.1415926535897932384626433832795


// --------- Random function ----------
float rand(float2 co) {
    return fract(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
}

// --------- Fragment shader ----------
[[ stitchable ]] half4 starfieldShader(
    float2 position,
    float2 size,
    float time
)
{
    float starSize = 10.0;
    float prob = 0.9;

    float2 pos = floor((1.0 / starSize) * position.xy);

    float color = 0.0;
    float starValue = rand(pos);

    if (starValue > prob)
    {
        float2 center = starSize * pos + float2(starSize, starSize) * 0.5;

        float t = 0.9 + 0.8 * sin(time + (starValue - prob) / (1.0 - prob) * 20);

        color = 1.0 - distance(position.xy, center) / (0.5 * starSize);
        color = color * t / (abs(position.y - center.y)) * t / (abs(position.x - center.x));
    }
    else if (rand(position.xy / size.xy) > 0.96)
    {
        float r = rand(position.xy);
        color = r * (1.2 * sin(time * (r * 8.0) + size.x * r) + 0.75);
        
    }

    return half4(half3(color), 1.0);
}
