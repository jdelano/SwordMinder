//
//  PixelatedDissolve.swift
//  SwordMinder
//
//  Created by John Delano on 2/6/23.
//

import SwiftUI

struct PixelatedDissolve: AnimatableModifier {
    var fractionComplete: Double
    
    func body(content: Content) -> some View {
        let pixels = 30
        let size = 1.0 / Double(pixels)
        content.overlay(
            Grid(horizontalSpacing: 0.0, verticalSpacing: 0.0) {
                ForEach(0..<pixels, id:\.self) { y in
                    GridRow {
                        ForEach(0..<pixels, id:\.self) { x in
                            Color.clear
                                .opacity(self.fractionComplete >= (Double(y) * size) + (Double(x) * size) ? 1 : 0)
                                .frame(width: size, height: size)
                        }
                    }
                }
            }
        )
    }
}

extension AnyTransition {
    static var pixelatedDissolve: AnyTransition {
        self.modifier(active: PixelatedDissolve(fractionComplete: 1.0),
                      identity: PixelatedDissolve(fractionComplete: 1.0))
    }
}
