//
//  Game.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

struct JM_VersePreview: View {
    //@State var verse = swordMinder.bible.text(for: verseReference)
    @ObservedObject var justMemorize: JustMemorize
    @EnvironmentObject var swordMinder: SwordMinder
    
    @Binding var currentView: JustMemorizeView.viewState
    
//    init(justMemorize: JustMemorize, toggleVerse: Bool, toggleTimer: Bool, timeRemaining: Int = 5) {
//        self.justMemorize = justMemorize
//        self.toggleVerse = toggleVerse
//        self.toggleTimer = toggleTimer
//        self.timeRemaining = timeRemaining
//    }
    
    var sampleVerse = "But that is not the way you learned Christ! Assuming that you have heard about him and were taught in him, as the truth is in Jesus, to put off your old self, which belongs to your former manner of life and is corrupt through deceitful desires, and to be renewed in the spirit of your minds, and to put on the new self, created after the likeness of God in true righteousness and holiness."
    var sampleReference = "Ephesians 4:20-24"
    
    var body: some View {
        // Give the lazy v-grid a go.
        VStack {
            HStack {
                Button {
                    withAnimation {
                        currentView = .mainMenu
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                        Text("Main Menu")
                    }
                }
                .foregroundColor(Color("JMLightGold"))
                .padding(.leading)
                Spacer()
            }
            //Title and points
            HStack {
                Image("JMLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                Spacer()
                Text("Score: 100")
                    .padding()
                    .foregroundColor(Color("JMLightGold"))
            }
            .padding(.leading)
            
            //Body
            Text("VERSE PREVIEW")
                .font(.headline)
                .padding()
                .foregroundColor(Color("JMWhite"))
                 //Text(verseReference.toString())
                .foregroundColor(Color("JMLightGold"))
            
                //Text((swordMinder.bible.text(for: verseReference)))
            
                //Text(JMVerse.verseArray)
                //Text()
        //        LazyVGrid(columns: 5) {
        //            ForEach
        //        }
                Text("\(sampleReference)")
                .foregroundColor(Color("JMLightGold"))
                Text("\(sampleVerse)")
                .foregroundColor(Color("JMLightGold"))
            
                .padding()
                .foregroundColor(Color("JMLightGold"))
            Spacer()
            HStack {
//                Button("Instructions") {
//                    withAnimation {
//                        currentView = .instructions
//                    }
//                }
//                .foregroundColor(Color("JMLightGold"))
//                .padding(.leading)
//                .padding(.leading)
//                Spacer()
                Button {
                    withAnimation {
                        currentView = .quizView
                    }
                } label: {
                    Text("Play")
                        .foregroundColor(Color("JMLightGold"))
                }
                .foregroundColor(Color("JMLightGold"))
//                .padding(.trailing)
//                .padding(.trailing)
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
        let justMemorize = JustMemorize(difficulty: "Easy", reference: Reference(), input: "Typing", toggleVerse: true, toggleTimer: true)
        JM_VersePreview(justMemorize: justMemorize, currentView: .constant(.versePreview))
            .environmentObject(SwordMinder())
    }
}
