//
//  GemView.swift
//  SwordMinder
//
//  Created by John Delano on 10/21/22.
//

import SwiftUI

struct GemView: View {
    var amount: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                GemShape()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(.accentColor3)
                    .shadow(radius: DrawingConstants.shadowRadius)
                Text("\(amount)")
                    .font(.system(size: DrawingConstants.fontSize))
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .scaleEffect(scale(thatFits: geometry.size, forValue: amount))
            }
        }
    }
    
    private func scale(thatFits size: CGSize, forValue value: Int) -> CGFloat {
        var scaleFactor = DrawingConstants.baseFontScale
        switch value {
            case 10..<100: scaleFactor = 0.55
            case 100..<1000: scaleFactor = 0.35
            case 1000..<10000: scaleFactor = 0.25
            default: break
        }
        return min(size.width, size.height) / (DrawingConstants.fontSize / scaleFactor)
    }
    
    private struct DrawingConstants {
        static let baseFontScale: CGFloat = 0.8
        static let fontSize: CGFloat = 10
        static let shadowRadius: CGFloat = 3
    }
    
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
}

struct GemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GemView(amount: 9)
                .frame(width: 35, height: 35)
            GemView(amount: 99)
                .frame(width: 35, height: 35)
            GemView(amount: 999)
                .frame(width: 35, height: 35)
            GemView(amount: 9999)
                .frame(width: 35, height: 35)

        }

    }
}
 
