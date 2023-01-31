//
//  FlashCardify.swift
//  SwordMinder
//
//  Created by John Delano on 10/24/22.
//

import SwiftUI

struct FlashCardify: AnimatableModifier {
    @Binding private var flipped: Bool
    
    var animatableData: CGFloat {
        get { rotationAngle }
        set { rotationAngle = newValue }
    }
    
    private var rotationAngle: Double

    init(flipped: Binding<Bool>, isFaceUp: Bool) {
        self.rotationAngle = isFaceUp ? 0 : 180
        _flipped = flipped
    }

    func body(content: Content) -> some View {
        ZStack {
            Group {
                let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if rotationAngle < 90 {
                    cardShape
                        .fill(.white)
                    cardShape
                        .strokeBorder(DrawingConstants.cardBorder, lineWidth: DrawingConstants.lineWidth)
                } else {
                   cardShape
                        .fill(DrawingConstants.cardBack)
                }
            }
            content
                .padding()
        }
        .foregroundColor(rotationAngle < 90 ? .black : .white)
        .padding()
        .modifier(FlipEffect(flipped: $flipped, angle: rotationAngle))
    }
    
    private struct FlipEffect: GeometryEffect {
        
        var animatableData: Double {
            get { angle }
            set { angle = newValue }
        }
        
        @Binding var flipped: Bool
        
        var angle: Double
        
        func effectValue(size: CGSize) -> ProjectionTransform {
            Task { @MainActor in
                self.flipped = self.angle >= 90 && self.angle < 270
            }
            let tweakedAngle = flipped ? -180 + angle : angle

            var transform3d = CATransform3DIdentity;

            transform3d.m34 = -1/max(size.width, size.height)
            transform3d = CATransform3DRotate(transform3d, CGFloat(Angle(degrees: tweakedAngle).radians), 0, 1, 0)
            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
            return ProjectionTransform(transform3d).concatenating(affineTransform)
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let cardFrontBackground: Color = .white
        static let cardBack: Color = .accentColor
        static let cardBorder: Color = .accentColor
    }

}

extension View {
    func flashCardify(isFaceUp: Bool, flipped: Binding<Bool>) -> some View {
        self.modifier(FlashCardify(flipped: flipped, isFaceUp: isFaceUp))
    }
}

