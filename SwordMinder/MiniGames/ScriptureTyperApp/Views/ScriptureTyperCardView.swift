//
//  ScriptureTyperCardView.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/12/22.
//

import SwiftUI

struct ScriptureTyperCardView: View {
    @State var isFaceUp: Bool
    var verseReference: String
    var verse: String
    var body: some View{
        ZStack{
            let cardShape = RoundedRectangle(cornerRadius: 15)
            if isFaceUp {
                cardShape.fill(.white)
                
                cardShape.strokeBorder(lineWidth: 3)
                Text(verse)
                    .font(.title)
            } else{
                cardShape.fill(.teal)
                Text(verseReference)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ScriptureTyperCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperCardView(isFaceUp: true, verseReference: "verse Reference", verse: "verse")
    }
}
