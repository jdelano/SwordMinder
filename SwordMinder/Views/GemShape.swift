//
//  GemShape.swift
//  SwordMinder
//
//  Created by John Delano on 10/21/22.
//

import SwiftUI

struct GemShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        // draw from the center of our rectangle
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius: CGFloat = min(rect.width, rect.height) / 2
        
        // start from directly upwards (as opposed to down or to the right)
        var currentAngle = Angle(degrees: -90)
        
        // calculate how much we need to move with each star corner
        let angleIncrement = Angle(degrees: 60)
        
        // we're ready to start with our path now
        var path = Path()
        
        // move to our initial position
        path.move(to: CGPoint(x: center.x + radius * cos(CGFloat(currentAngle.radians)), y: center.y + radius * sin(currentAngle.radians)))
        
        // loop over all our points
        for _ in 0..<6  {
            // figure out the location of this point
            let sinAngle = sin(currentAngle.radians)
            let cosAngle = cos(currentAngle.radians)
            path.addLine(to: CGPoint(x: center.x + radius * cosAngle, y: center.y + radius * sinAngle))
            // move on to the next corner
            currentAngle += angleIncrement
        }
        return path
    }
}
 
