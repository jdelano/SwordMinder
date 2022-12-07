//
//  ScriptureTyperVerses.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/7/22.
//

import SwiftUI

struct ScriptureTyperVerses: View {
    @State var verses = ["John 11:35","John 11:35","John 11:35","John 11:35","John 11:35","John 11:35"]
    ///Requirement: The mini-game will be able to access the verses used in the flashcards for Sword Minder
    ///Requirement: When the continue button is selected, a series of verse cards will be displayed
    var body: some View {
        VStack {
            Text("Choose your Verse!").font(.largeTitle).fontWeight(.heavy)
            ScrollView{
                ForEach(verses, id: \.self, content: { verses in
                    CardView(cardContent: verses)
                        .aspectRatio(3/2, contentMode: .fit)
                        .foregroundColor(.black)
                })
            }
        }.padding()
    }
}

struct CardView: View {
    var cardContent: String
    var body: some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: 15)
            cardShape.fill(.teal)
            cardShape.strokeBorder(lineWidth: 3)
            NavigationLink(destination:  ScriptureTyperGame()
            ) {Text(cardContent)
                .foregroundColor(.white) .font(.largeTitle)}
            //Requirement -- edited for ease of use
            ///When a verse is chosen and selected, a start button will be displayed.
        }
    }
}

struct ScriptureTyperVerses_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperVerses()
    }
}
