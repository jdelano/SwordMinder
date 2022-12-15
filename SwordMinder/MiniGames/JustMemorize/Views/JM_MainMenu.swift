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
    
    /// This is what connects your app back to the SwordMinder app. Change this binding to return to Sword Minder
    @Binding var currentApp: Apps
    
    @Binding var currentView: JustMemorizeView.viewState
    @Binding var toggleVerse: Bool
    
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
                            playAndVerses
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
        VStack {
            HStack {
                Button {
                    withAnimation {
                        /// To return to SwordMinder, simply set the currentApp binding back to .swordMinder
                        currentApp = .swordMinder
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                        Text("Swordminder")
                    }
                }
                .foregroundColor(Color("JMLightGold"))
                .padding(.leading)
                Spacer()
            }
            HStack {
                Image("JMLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                Spacer()
                    //Code generously adapted from Andrew Wordhouse.
                    Button {
                        withAnimation {
                            currentView = .settings
                        }
                    } label: {
                        Image(systemName: "gear")
                            .font(.title2)
                            .foregroundColor(Color("JMLightGold"))
                    }
                    .padding()
            }
        }
    }
    
    var playAndVerses: some View {
            HStack{
                Spacer()
                Button("Play") {
                    withAnimation {
                        toggleVerse == true ? (currentView = .versePreview) : (currentView = .quizView)
                    }
                }
                .foregroundColor(Color("JMLightGold"))
                Spacer()
            }
            .frame(width: 400, height: 50)
            .border(Color("JMDarkGold"))
    }
    
    var bottomMenu: some View {
        HStack {
            Spacer()
            Button("Instructions") {
                withAnimation {
                    currentView = .instructions
                }
            }
            .foregroundColor(Color("JMLightGold"))
            .padding()
            Spacer()
            Button("Add High Score") {
                /// To add a high score entry, use the view model's highScore function
                ///  and pass in the name of your app, along with the user's current high score.
                swordMinder.highScore(app: "Just Memorize", score: 5000)
            }
            .foregroundColor(Color("JMLightGold"))
            Spacer()
        }// HStack
        .frame(width: 370, height: 50)
        .border(Color("JMDarkGold"))
    }
    
}//Struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        JM_MainMenu(currentApp: .constant(.justMemorizeApp), currentView: .constant(.mainMenu), toggleVerse: .constant(true))
            .environmentObject(SwordMinder())
            //.environment(\.colorScheme, .dark)
    }
}
