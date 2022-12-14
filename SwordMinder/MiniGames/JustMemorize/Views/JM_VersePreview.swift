//
//  Game.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

struct JM_VersePreview: View {
    //@State var verse = swordMinder.bible.text(for: verseReference)
    @State var verseReference: Reference
    @EnvironmentObject var swordMinder: SwordMinder
    
    // Timer graciously given by Michael Smithers.
    @State private var timeRemaining = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    ///var sampleVerse = "But that is not the way you learned Christ! Assuming that you have heard about him and were taught in him, as the truth is in Jesus, to put off your old self, which belongs to your former manner of life and is corrupt through deceitful desires, and to be renewed in the spirit of your minds, and to put on the new self, created after the likeness of God in true righteousness and holiness."
    ///var sampleReference = "Ephesians 4:20-24"
    
    var body: some View {
        // Give the lazy v-grid a go.
        VStack {
            //Title and points
            HStack {
                Text("(Just Memorize Logo)")
                    .foregroundColor(Color("JMLightGold"))
                    Spacer()
                Text("Points: 100")
                    .padding()
                    .foregroundColor(Color("JMLightGold"))
            }
            .padding(.leading)
            
            //Body
            Text("VERSE PREVIEW")
                .font(.headline)
                .padding()
                .foregroundColor(Color("JMLightGold"))
                 Text(verseReference.toString())
                .foregroundColor(Color("JMLightGold"))
            
                Text((swordMinder.bible.text(for: verseReference)))
                //Text()
        //        LazyVGrid(columns: 5) {
        //            ForEach
        //        }
            
            
                .padding()
                .foregroundColor(Color("JMLightGold"))
            Spacer()
            HStack {
                NavigationLink("Instructions", destination: JM_Instructions())
                .foregroundColor(Color("JMLightGold"))
                .padding(.leading)
                .padding(.leading)
                Spacer()
                NavigationLink("Start", destination: JM_QuizView())
                .foregroundColor(Color("JMLightGold"))
                .padding(.trailing)
                .padding(.trailing)
            }
            .frame(width: 400, height: 50)
            .border(Color("JMLightGold"))
            .padding()
        }
        .background(Color("JMBlack"))
    }//body
}

struct Game_Previews: PreviewProvider {
    static var previews: some View {
        JM_VersePreview(verseReference: Reference())
            .environmentObject(SwordMinder())
    }
}
