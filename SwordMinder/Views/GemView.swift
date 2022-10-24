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
 
