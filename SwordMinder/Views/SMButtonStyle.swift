//
//  SMButtonStyle.swift
//  SwordMinder
//
//  Created by John Delano on 9/28/22.
//

import SwiftUI

struct SMButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.body)
            .fontWeight(.black)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(5)
            .shadow(color:.black, radius:1)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
    }
}
