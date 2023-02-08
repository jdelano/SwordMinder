//
//  SwiftUIView.swift
//  SwordMinder
//
//  Created by John Delano on 2/1/23.
//

import SwiftUI

struct PipeShape: Shape, Identifiable {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let pipeWidth: CGFloat
    let id = UUID()
    
    func path(in rect: CGRect) -> Path {
        let length = hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y) + pipeWidth
        let rect = CGRect(x: 0, y: 0, width: length, height: pipeWidth)
        let radius = pipeWidth / 2
        let path = Path(roundedRect: rect, cornerRadius: radius)
        let angle:CGFloat = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
        let transform = CGAffineTransform(translationX: startPoint.x, y: startPoint.y)
            .rotated(by: angle)
            .translatedBy(x: -radius, y: -radius)
        return path.applying(transform)
    }
}

struct PipeShape_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            PipeShape(startPoint: CGPoint(x: 100, y: 100), endPoint: CGPoint(x: 200.0, y: 200.0), pipeWidth: 30)
                .stroke(lineWidth: 2.0)
        }
    }
}
