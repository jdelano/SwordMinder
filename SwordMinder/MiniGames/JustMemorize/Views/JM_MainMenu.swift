//
//  JM_MainMenu.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/9/22.
//

import SwiftUI

struct JM_MainMenu: View {
    /// Need this in each of your views so that you can access the sword minder view model
    /// You can of course add your own EnvironmentObjects as well to access your own view models
    @EnvironmentObject var swordMinder: SwordMinder
    @ObservedObject var justMemorize: JustMemorize
    
    /// This is what connects your app back to the SwordMinder app. Change this binding to return to Sword Minder
    @Binding var currentApp: Apps
    
    @Binding var toggleVerse: Bool
    @Binding var toggleTimer: Bool
    
    var body: some View {
        ZStack {
            VStack {
                // A basic navigation stack.
                NavigationView {
                    VStack {
                        topMenu
                        Spacer()
                        //Title
                        Text("Just Memorize.")
                            .font(.largeTitle)
                            .foregroundColor(Color("JMWhite"))
                        Spacer()
                        VStack {
                            playAndLearn
                            bottomMenu
                        }
                    }
                    .background(Color("JMBlack"))
                }// Navigation Stack
            }// VStack
            .padding()
        }// ZStack
        .background(Color("JMBlack"))
    }// Body
    
    var topMenu: some View {
        HStack {
//            Text("(Just Memorize Logo)")
//                .padding()
//                .border(Color("JMDarkGold"))
//                .foregroundColor(Color("JMDarkGold"))
            Image("JMLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            Spacer()
            ZStack {
                NavigationLink("       ", destination: JM_Settings(justMemorize: JustMemorize(difficulty: "Easy", reference: Reference(), input: "Typing", toggleVerse: toggleVerse, toggleTimer: toggleTimer)))
                    .foregroundColor(Color("JMLightGold"))
                               Image(systemName: "gear")
                        .foregroundColor(Color("JMLightGold"))
                        .padding()
            }
        }
    }
    
    var playAndLearn: some View {
            HStack{
                Spacer()
                NavigationLink("Learn", destination: JM_Instructions())
                    .foregroundColor(Color("JMLightGold"))
                Spacer()
                if toggleVerse == true {
                    NavigationLink("Play", destination: JM_VersePreview(justMemorize: justMemorize, toggleVerse: $toggleVerse, toggleTimer: $toggleTimer))
                        .foregroundColor(Color("JMLightGold"))
                        .padding()
                } else {
                    NavigationLink("Play", destination: JM_QuizView(justMemorize: justMemorize, toggleVerse: $toggleVerse, toggleTimer: $toggleTimer))
                        .foregroundColor(Color("JMLightGold"))
                        .padding()
                }
                Spacer()
//              Button("TestButton") {
//              JustMemorizeView(currentJMView: .instructions)
//              }
            }
            .frame(width: 400, height: 50)
            .border(Color("JMDarkGold"))
                                
//                func verseNoverse(setting: Bool) -> any View {
//                if setting == true {
//                    return JM_VersePreview(verseReference: Reference())
//                } else {
//                    return JM_QuizView()
//                }
//            }
    }
    
    var bottomMenu: some View {
        HStack {
            Spacer()
            Button("Return to SwordMinder!") {
                withAnimation {
                    /// To return to SwordMinder, simply set the currentApp binding back to .swordMinder
                    currentApp = .swordMinder
                }
            }
            .foregroundColor(Color("JMLightGold"))
            Spacer()
            Button("Add High Score Entry") {
                /// To add a high score entry, use the view model's highScore function
                ///  and pass in the name of your app, along with the user's current high score.
                swordMinder.highScore(app: "Just Memorize", score: 5000)
            }
            .foregroundColor(Color("JMLightGold"))
            Spacer()
        }// HStack
        .frame(width: 400, height: 50)
        .border(Color("JMDarkGold"))
    }
    
}//Struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let justMemorize = JustMemorize(difficulty: "Easy", reference: Reference(), input: "Typing", toggleVerse: true, toggleTimer: true)
        JM_MainMenu(justMemorize: justMemorize, currentApp: .constant(.justMemorizeApp), toggleVerse: .constant(true), toggleTimer: .constant(true))
            .environmentObject(SwordMinder())
            //.environment(\.colorScheme, .dark)
    }
}
