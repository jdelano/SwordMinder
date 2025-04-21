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
    var fontSize: CGFloat = 12
    
    var body: some View {
        VStack(spacing: -fontSize) {
            Image("gem")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: fontSize + DrawingConstants.gemFrameOffset)
            ZStack {
                // Glowing base
                Text("\(amount)")
                    .font(.system(size: fontSize, weight: .bold, design: .rounded))
                    .foregroundStyle(.orange)
                    .shadow(color: .black.opacity(0.6), radius: fontSize * 0.05, x: 0, y: fontSize * 0.05)
                    .shadow(color: .black.opacity(0.4), radius: fontSize * 0.1, x: 0, y: fontSize * 0.1)
                
                // Highlight stroke for dimensional edge
                Text("\(amount)")
                    .font(.system(size: fontSize, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.1))
            }
            .fixedSize(horizontal: true, vertical: true)
        }
        .labelStyle(.titleAndIcon)
    }
    
    private struct DrawingConstants {
        static let gemFrameOffset: CGFloat = 10
    }
}

#Preview {
    GemView(amount: 198)
}
