//
//  RulesView.swift
//  Final Project
//
//  Created by Michael Smithers on 11/9/22.
//

import SwiftUI

struct RulesView: View {
    @Binding var currentApp: Apps
    @State var passage: Passage
    @State private var settingsShown: Bool = false
    @EnvironmentObject var swordMinder: SwordMinder
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Spacer(minLength: 170)
                    rulesLabel
                    Spacer()
                    settings
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
    
    var settings: some View {
        Button {
            settingsShown = true
        } label: {
            Image(systemName: "gear")
                .padding(5)
        }
        .buttonStyle(SMButtonStyle())
        .padding()
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
                Text("1. Speak the Verse to make the blird fly. Say the word before the mountain")
                    .padding([.leading, .bottom, .trailing])
                Spacer()
            }
            HStack {
                Text("2. You have 45 seconds")
                    .padding([.leading, .bottom, .trailing])
                Spacer()
                
            }
            HStack {
                Text("3. When an incorrect word is spoken, time will decrease 1 second")
                    .padding([.leading, .bottom, .trailing])
                Spacer()
            }
            
            HStack {
                Text("4. The game will start as soon as you press continue")
                    .padding([.leading, .bottom, .trailing])
                Spacer()
            }
            
            
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
            Text(swordMinder.bible.text(for: passage))
                .padding()
            Text(passage.referenceFormatted)
                .padding()
        }
    }
    
    var toGameView: some View {
        NavigationLink(destination: FlappyMemoryView(game: GameScene(), currentApp: $currentApp, passage: Passage())) {
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
        RulesView(currentApp: .constant(.flappyMemoryApp), passage: Passage())
            .environmentObject(SwordMinder())
    }
}
