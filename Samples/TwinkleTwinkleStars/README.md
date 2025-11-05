# TimelineView Example [DRAFT]

This litle experiment was born from the idea "how to make animated backgrounds with SwiftUI". Sure, one could use metal and shaders to apply the desired effect, but I was looking for a away to do this without using shaders.

## A lot of Stars

My idea then was to create a background of flickering stars. A simple loop through some rects, drawing the circles and that`s it!

I could do it using the Circle or Rectangle components, but to fill the iPhone screen I would need at least 200 components on the screen. When We imagine an app with a background that has 200 views with an infinite scroll view... Things start to get slow for the SwiftUI render.

## Canvas

Canvas view is a SwiftUI component that can be used to draw things directly on the screen. With that in place is possible to draw as many stars as the screen can fill.

But just putting the stars there, doesn`t mean they will animate or twinkle. To that directly in a canvas would be a lot of work.

## TimelineView to the rescue!

With the TimelineView is possible to animate views inside this definition.