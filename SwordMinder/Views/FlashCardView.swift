//
//  FlashCardView.swift
//  SwordMinder
//
//  Created by John Delano on 9/26/22.
//

import SwiftUI

struct FlashCardView: View {
    @State var isFaceUp: Bool = true
    var passage: Bible.Passage
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.black, lineWidth: 3)
            Text(!isFaceUp ? .init(passage.text) : .init(passage.reference))
                .padding()
        }
        .aspectRatio(5/3, contentMode: .fit)
        .padding()
        .onTapGesture {
            withAnimation {
                isFaceUp.toggle()
            }
        }
        
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        let bible = Bible(translation: .kjv)
        let passage = bible.passage(from: Bible.Reference(fromString: "John 3:16"))!
        FlashCardView(passage: passage)
    }
}
