//
//  GemView.swift
//  SwordMinder
//
//  Created by John Delano on 10/21/22.
//

import SwiftUI

/// A View that depicts a Gem representing in-game currency with a number superimposed on top
struct GemView: View {
    /// The number that will be superimposed on the Gem shape
    var amount: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
//                GemShape()
//                    .fill(LinearGradient(colors: [.accentColor3, .accentColor2], startPoint: .top, endPoint: .bottom))
//                    .aspectRatio(1, contentMode: .fit)
//                    .shadow(radius: DrawingConstants.shadowRadius)
                Image("gem")
                    .resizable()
                    .scaleEffect(scale(thatFits: geometry.size, forValue: 999))
                Text("\(amount)")
                    .font(.system(size: DrawingConstants.fontSize))
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .scaleEffect(scale(thatFits: geometry.size, forValue: 999))
            }
        }
    }
    
    /// Determine the correct scale to display the number of gems on top of the shape, so that the number is as big as possible without going outside the bounds of the shape.
    /// - Parameters:
    ///   - size: The CGSize representing the bounds of the shape
    ///   - value: The value that will be displayed; used to determine the number of digits we have to account for.
    /// - Returns: The scale factor to use in the scaleEffect view modifier to shrink or expand the text
    private func scale(thatFits size: CGSize, forValue value: Int) -> CGFloat {
        var scaleFactor: CGFloat
        switch value {
            case 0..<10:  scaleFactor = DrawingConstants.oneDigitFontScale
            case 10..<100: scaleFactor = DrawingConstants.twoDigitFontScale
            case 100..<1000: scaleFactor = DrawingConstants.threeDigitFontScale
            case 1000..<10000: scaleFactor = DrawingConstants.fourDigitFontScale
            default: scaleFactor = DrawingConstants.fourDigitFontScale // At five digits or more, the number is just going to spill outside the shape, because if we shrink it any further, it will be too small to see.
        }
        return min(size.width, size.height) / (DrawingConstants.fontSize / scaleFactor)
    }
    
    /// Draws a Hexagon shape with the point facing upward
    private struct GemShape : Shape {
        
        /// Returns the path of the Gem Shape
        /// - Parameter rect: The rectangular area enclosing the shape
        /// - Returns: The Path object representing the shape
        func path(in rect: CGRect) -> Path {
            // draw from the center of our rectangle
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius: CGFloat = min(rect.width, rect.height) / 2
                        
            // Start a new path...
            var path = Path()
            
            // move to the initial position
            path.move(to: CGPoint(x: center.x + radius * cos(CGFloat(Angle(degrees: DrawingConstants.startAngle).radians)),
                                  y: center.y + radius * sin(CGFloat(Angle(degrees: DrawingConstants.startAngle).radians))))
            
            // loop over all points of the Gem's Shape
            for side in 1...DrawingConstants.shapePoints  {
                let angle = Angle(degrees: DrawingConstants.startAngle + (CGFloat(side) * DrawingConstants.anglePerSide))

                path.addLine(to: CGPoint(x: center.x + radius * cos(CGFloat(angle.radians)),
                                         y: center.y + radius * sin(CGFloat(angle.radians))))
                // move on to the next vertex
            }
            return path
        }
    }
    
    private struct DrawingConstants {
        static let oneDigitFontScale: CGFloat = 0.8
        static let twoDigitFontScale: CGFloat = 0.55
        static let threeDigitFontScale: CGFloat = 0.35
        static let fourDigitFontScale: CGFloat = 0.25
        static let fontSize: CGFloat = 10
        static let shadowRadius: CGFloat = 3
        static let shapePoints: Int = 6 // hexagonal shapes
        static let anglePerSide: CGFloat = 360 / CGFloat(shapePoints)
        static let startAngle: CGFloat = -90 // Gem should point upwards.
    }

}

struct GemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GemView(amount: 999)
                .frame(width: 30, height: 25)
        }
    }
}
 
