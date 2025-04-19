//
//  FlashCardView.swift
//  SwordMinder
//
//  Created by John Delano on 9/26/22.
//

import SwiftUI

struct FlashCardView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @State private var isFaceUp: Bool = false
    @State private var flipped: Bool = false
    @State private var flippedCount: Int = 0
    @State private var verseText: String = ""
    @State var passage: Passage
    var body: some View {
        ZStack(alignment: .center) {
            Text(.init(passage.referenceFormatted))
                .opacity(flipped ? 1 : 0)
            ScrollView {
                Text(.init(self.verseText))
                    .opacity(flipped ? 0 : 1)
            }
        }
        .flashCardify(isFaceUp: isFaceUp, flipped: $flipped)
        .onTapGesture {
            withAnimation(.linear(duration: 0.8)) {
                isFaceUp.toggle()
                if isFaceUp {
                    flippedCount += 1
                }
            }
        }
        .onChange(of: flippedCount) { count in
            swordMinder.reviewPassage(passage)
            if count == 3 {
                swordMinder.completeTask(difficulty: 1)
            }
        }
        .onAppear {
            Task { @MainActor in
                self.verseText = (try? await passage.text()) ?? ""
            }
        }
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView(passage: Passage())
            .environmentObject(SwordMinder())
    }
}
