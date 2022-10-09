//
//  ButtonStyle.swift
//  SwordMinder
//
//  Created by John Delano on 9/28/22.
//

import SwiftUI

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(5)
            .background(Color.accentColor)
            .cornerRadius(20)
            .shadow(color:.black, radius:4)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}
