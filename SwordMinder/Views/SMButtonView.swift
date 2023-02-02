//
//  SMButtonView.swift
//  SwordMinder
//
//  Created by John Delano on 9/28/22.
//

import SwiftUI

struct SMButtonView<GlyphView : View>: View {
    var caption: String = ""
    var glyph: () -> GlyphView
    var action: () -> Void
    var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Spacer()
                    glyph()
                        .padding([.top, .bottom], 3)
                    Text(caption)
                    Spacer()
                }
            }
            .buttonStyle(SMButtonStyle())
    }
    
    init(caption: String, @ViewBuilder glyph: @escaping () -> GlyphView, action: @escaping () -> Void) {
        self.caption = caption
        self.glyph = glyph
        self.action = action
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SMButtonView(caption: "Level Up") {
            GemView(amount: 3)
                .frame(width: 25, height: 25)
        } action: {
            
        }
    }
}
