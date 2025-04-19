//
//  SMButtonStyle.swift
//  SwordMinder
//
//  Created by John Delano on 9/28/22.
//

import SwiftUI

struct SMButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration
//            .label
//            .font(.body)
//            .fontWeight(.black)
//            .foregroundColor(.white)
//            .background(Color.accentColor)
//            .cornerRadius(5)
//            .shadow(color:.black, radius:1)
//            .opacity(configuration.isPressed ? 0.6 : 1.0)
//            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
//    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.32, green: 0.53, blue: 1.0), // light top blue
                                Color(red: 0.12, green: 0.32, blue: 0.85)  // deeper bottom blue
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(configuration.isPressed ? 0.1 : 0.25),
                            radius: configuration.isPressed ? 1 : 3,
                            x: 0, y: configuration.isPressed ? 1 : 2)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
