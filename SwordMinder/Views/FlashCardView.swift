//
//  FlashCardView.swift
//  SwordMinder
//
//  Created by John Delano on 9/26/22.
//

import SwiftUI

struct FlashCardView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @State var isFaceUp: Bool = false
    @State var flipped: Bool = false
    var passage: Passage
    var body: some View {
        ZStack {
            Text(.init(passage.referenceFormatted))
                .opacity(flipped ? 1 : 0)
            Text(.init(swordMinder.bible.text(for: passage)))
                .opacity(flipped ? 0 : 1)
        }
        .flashCardify(isFaceUp: isFaceUp, flipped: $flipped)
        .onTapGesture {
            withAnimation(.linear(duration: 0.8)) {
                isFaceUp.toggle()
            }
        }
    }
}

//struct FlashCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let bible = Bible()
//        let passage = bible.passage(from: (try? Bible.Reference(fromString: "John 3:16"))!)!
//        FlashCardView(passage: passage)
//    }
//}
