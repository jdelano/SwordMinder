//
//  RulesView.swift
//  Final Project
//
//  Created by Michael Smithers on 11/9/22.
//

import SwiftUI

struct RulesView: View {
    @Binding var currentApp: Apps
    var passage: Passage
    @State private var settingsShown: Bool = false
    @ObservedObject var flappyMemoryViewModel: GameScene
    @EnvironmentObject var swordMinder: SwordMinder
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Spacer(minLength: 155)
                    rulesLabel
                    Spacer()
                    Button {
                        settingsShown = true
                    } label: {
                        Image(systemName: "gear")
                            .padding(5)
                    }
                    .buttonStyle(SMButtonStyle())
                    .padding()
                }.sheet(isPresented: $settingsShown, onDismiss: { settingsShown = false }) {
                    FlappyMemorySettingsView(difficultyFlappy: $flappyMemoryViewModel.difficultyFlappy)

                }
                rules
                verseTitle
                verse
                Spacer()
                Button("Return to SwordMinder") {
                    //This will have  the code to return to the main game
                    withAnimation {
                        currentApp = .swordMinder
                    }
                }
                toGameView
            }
        }
    }
    
    var rulesLabel: some View {
        Text("Rules:")
            .font(.largeTitle)
            .fontWeight(.medium)
            .foregroundColor(Color.blue)
    }
    
    var rules: some View {
        VStack {
            //Rules listing
            
            HStack {
                Text("1. The game will start as soon as you press continue")
                    .padding([.leading, .bottom, .trailing])
                Spacer()
            }
            HStack {
                Text("2. Recite scripture to yourself as you go. Honor system.")
                    .padding([.leading, .bottom, .trailing])
                Spacer()
            }
//            HStack {
//                Text("3. Speak the Verse to make the blird fly. Say the word before the mountain")
//                    .padding([.leading, .bottom, .trailing])
//                Spacer()
//            }
//            HStack {
//                Text("4. You have 45 seconds")
//                    .padding([.leading, .bottom, .trailing])
//                Spacer()
//
//            }
//            HStack {
//                Text("5. When an incorrect word is spoken, time will decrease 1 second")
//                    .padding([.leading, .bottom, .trailing])
//                Spacer()
//            }
//            HStack {
//                Text("6. Recording will begin immediately")
//                    .padding([.leading, .bottom, .trailing])
//                Spacer()
//            }
            
        }
    }
    
    var verseTitle: some View {
        Text("Verse:")
            .font(.largeTitle)
            .fontWeight(.medium)
            .foregroundColor(Color.blue)
        
        //Place code to view verse being studied from SwordMinder
    }
    
    var verse: some View {
        VStack {
//            Text(swordMinder.bible.text(for: passage))
//                .padding()
            Text(passage.referenceFormatted)
                .padding()
        }
    }
    
    var toGameView: some View {
        NavigationLink(destination: FlappyMemoryView(game: GameScene(), currentApp: $currentApp, passage: swordMinder.passages.randomElement() ?? Passage())) {
            Text("Continue")
                .frame(minWidth: 0, maxWidth: 300)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40)
                .font(.title)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView(currentApp: .constant(.flappyMemoryApp), passage: Passage(), flappyMemoryViewModel: GameScene())
            .environmentObject(SwordMinder())
    }
}
