//
//  ScriptureTyperCardView.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/12/22.
//

import SwiftUI

struct ScriptureTyperCardView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @State private var isFaceUp: Bool = false
    @State private var flipped: Bool = false
    @State private var flippedCount: Int = 0
    var passage: Passage
    var body: some View{
        ZStack(alignment: .center) {
            Text(.init(passage.referenceFormatted))
                .opacity(flipped ? 0 : 1)
            ScrollView {
                Text(.init(swordMinder.bible.text(for: passage)))
                    .opacity(flipped ? 1 : 0)
            }
        }
        .flashCardify(isFaceUp: isFaceUp, flipped: $flipped)
        .onTapGesture {
            withAnimation(.linear(duration: 0.8)) {
                isFaceUp.toggle()
            }
        }
    }
}

struct ScriptureTyperCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperCardView(passage: Passage())
    }
}
