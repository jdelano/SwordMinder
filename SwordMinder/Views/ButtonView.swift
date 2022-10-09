//
//  ButtonView.swift
//  SwordMinder
//
//  Created by John Delano on 9/28/22.
//

import SwiftUI

struct ButtonView: View {
    var glyph: String
    var caption: String
    var action: () -> Void
    var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Image(systemName: glyph)
                    Text(caption)
                }
            }
            .buttonStyle(BlueButtonStyle())
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(glyph: "pencil", caption: "Upgrade ...", action: { })
    }
}
