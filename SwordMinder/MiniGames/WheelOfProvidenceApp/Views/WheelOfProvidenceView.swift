//
//  WheelOfProvidenceView.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import SwiftUI

enum gameState {
    case wheel
    case guesser
    case complete
}
struct WheelOfProvidenceView: View {
    @ObservedObject var wheelOfProvidence: WheelOfProvidence
    @State var currentGameState = gameState.wheel
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var currentApp: Apps
    @State private var presentLetterAlert = false
    @State private var presentPhraseAlert = false
    @State var guess = ""
    
    var passage: Passage
    var body: some View {
        VStack{
            switch currentGameState {
                    case .wheel:
                VStack {
                    WheelView()
                        .rotationEffect(Angle.radians(wheelOfProvidence.spinDouble * (Double.pi / 2.0)))
                    HStack{
                        Button("Spin!", action: {
                        withAnimation(.easeInOut, {
                            if(wheelOfProvidence.wheel.isSpun == false){
                                wheelOfProvidence.spinWheel()
                            }
                        })
                        })
                        Button(wheelOfProvidence.wheel.isSpun ? "Start!" : " ", action: {
                            if(wheelOfProvidence.wheel.isSpun == true){
                                currentGameState = .guesser
                            }
                        })
                    }
                }
                    case .guesser:
                        VStack{
                            ScoreView()
                            
                            /// WordView
                            var word = wheelOfProvidence.grid
                            let length: Int = word.count
                            LazyVGrid(columns:[GridItem(.fixed(50)),GridItem(.fixed(50)),GridItem(.fixed(50)),GridItem(.fixed(50)),GridItem(.fixed(50)),GridItem(.fixed(50))]){
                                Spacer()
                                ForEach(0..<length, id: \.self){index in
                                    LetterView(letter: word[index].isShown ? word[index].letter : Character(" "))
                                        .aspectRatio(2/3, contentMode: .fill)
                                }
                                Spacer()
                            }
                            
                            ///BottomMenu
                            HStack{
                                Spacer()
                                Button("Guess", action:{
                                    presentLetterAlert = true
                                }).foregroundColor(.white).padding().alert("Guess Letter:", isPresented: $presentLetterAlert, actions: {
                                    TextField("Capital Letter", text: $guess)
                                    
                                    Button("Submit", action: {
                                        wheelOfProvidence.guessLetter(guess)
                                        if(wheelOfProvidence.containsGuessedLetter()){
                                            wheelOfProvidence.updateGrid(guess)
                                        }
                                        presentLetterAlert = false
                                    })
                                })
                                Spacer()
                                Button("Complete", action:{
                                    presentPhraseAlert = true
                                }).foregroundColor(.white).padding().alert("Guess Letter:", isPresented: $presentPhraseAlert, actions: {
                                    TextField("Capital Letter", text: $guess)
                                    
                                    Button("Submit", action: {
                                        wheelOfProvidence.guessedPhrase = guess
                                        if(wheelOfProvidence.guessedPhraseIsCorrect()){
                                            currentGameState = .complete
                                            if(swordMinder.taskEligible) {
                                                swordMinder.completeTask(difficulty: wheelOfProvidence.award)
                                            }
                                        }
                                        presentPhraseAlert = false
                                    })
                                })
                                Spacer()
                            }.background(Color.blue)
                        }
                        case .complete:
                            VStack {
                                Text("Correct!").font(.largeTitle)
                                Text("Score: \(wheelOfProvidence.score)").font(.title)
                                Text("You received \(wheelOfProvidence.award) gems!").font(.title2)
                            }
                    }
                Button {
                    currentApp = .swordMinder
                } label: {
                    Text("Return to Sword Minder")
                        .padding()
                }
                .padding()
                .buttonStyle(SMButtonStyle())
        }
        .onAppear{
            wheelOfProvidence.verse = swordMinder.bible.text(for: passage)
        }
    }
}
struct WordView: View {
    var body: some View {
        GeometryReader { geometry in
            
        }
    }
}

struct LetterView: View{
    var letter: Character
    //will allow for a boolean: "isGuessed" or something of that nature, determining whether or not the letter shows. Think of a "flipped card", almost.
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(letter == " " ? .white:.blue)
                Text(String(letter)).font(.system(size: geometry.size.width))
            }
        }
    }
}

struct ScoreView: View{
    var body: some View{
        let score: Int = 316 //This is a let constant to remove the warning: will shift to var when needed
        let remaining: Int = 9 //This will be the amount of verses remaining in the game. This will be preset per game, to allow for standardization of scoring
        HStack{
            Text("Score: ")
            Text(String(score))
            Spacer()
            Text("Remaining Verses: " + String(remaining))
        }.font(.system(size: 20)).padding(.horizontal).background(Color.blue)
    }
}

struct BottomMenu: View{
    var body: some View{
        HStack{
            Spacer()
            Button("Guess", action:{
                //Allow entry of one letter, check if it applies to the phrase
            }).foregroundColor(.white).padding()
            Spacer()
            Button("Complete", action:{
                //Allow for the completion of the verse by typing the entire verse
            }).foregroundColor(.white).padding()
            Spacer()
        }.background(Color.blue)
    }
}


struct WheelOfProvidenceView_Previews: PreviewProvider {
    static var previews: some View {
        WheelOfProvidenceView(wheelOfProvidence: WheelOfProvidence(), currentApp: .constant(.wheelOfProvidenceApp), passage: Passage())
    }
}

