//
//  SMButtonStyle.swift
//  SwordMinder
//
//  Created by John Delano on 9/28/22.
//

import SwiftUI

struct SMButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: isEnabled
                        ? [Color.white, Color.white.opacity(0.70)]
                        : [Color.white.opacity(0.70), Color.white.opacity(0.40)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.4), radius: 1, x: 1, y: 1)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .background(
            ZStack {
                // Base gradient
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: isEnabled
                                               ? (configuration.isPressed
                                                  ? [.blue.opacity(0.85), .blue.opacity(0.85)]
                                                  : [.blue, .blue.opacity(0.90)])
                                               : [.gray, .gray]
                                              ),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                if !configuration.isPressed {
                    // Inner shadow
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .offset(x: 0.5, y: 0.5)
                }
            }
        )
        .shadow(color: isEnabled
                ? .black.opacity(configuration.isPressed ? 0.1 : 0.25)
                : .black.opacity(0.05),
                radius: configuration.isPressed ? 1 : 2,
                x: 0,
                y: configuration.isPressed ? 1 : 2)
        .offset(x: configuration.isPressed ? -1 : 0, y: configuration.isPressed ? -1 : 0)
        .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}


#Preview {
    Button {
    } label: {
        Text("Demo")
    }
    .buttonStyle(SMButtonStyle())
    .disabled(false)
    
    Button {
    } label: {
        Text("Demo")
    }
    .buttonStyle(SMButtonStyle())
    .disabled(true)
}
