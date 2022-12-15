//
//  JustMemorizeView.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/14/22.
//

import SwiftUI

struct JustMemorizeView: View {
    
    @State private var currentView: viewState = .mainMenu
    @ObservedObject var justMemorize: JustMemorize
    
    /// Need this in each of your views so that you can access the sword minder view model
    /// You can of course add your own EnvironmentObjects as well to access your own view models
    @EnvironmentObject var swordMinder: SwordMinder
    
    /// This is what connects your app back to the SwordMinder app. Change this binding to return to Sword Minder
    @Binding var currentApp: Apps
    
    @Binding var toggleVerse: Bool
    @Binding var toggleTimer: Bool
    
    //Code generously adapted from Andrew Wordhouse.
    var body: some View {
        switch currentView {
            case .mainMenu: JM_MainMenu(currentApp: $currentApp, currentView: $currentView, toggleVerse: $toggleVerse)
                .transition(.opacity)
                .background(Color("JMBlack"))
            case .versePreview: JM_VersePreview(justMemorize: justMemorize, currentView: $currentView)
                .transition(.opacity)
                .background(Color("JMBlack"))
            case .quizView: JM_QuizView(justMemorize: justMemorize, currentView: $currentView, toggleTimer: $toggleTimer)
                .transition(.opacity)
                .background(Color("JMBlack"))
            case .results: JM_Results(justMemorize: justMemorize, currentView: $currentView, toggleVerse: $toggleVerse)
                .transition(.opacity)
                .background(Color("JMBlack"))
            case .instructions: JM_Instructions(currentView: $currentView)
                .transition(.opacity)
                .background(Color("JMBlack"))
            case .settings: JM_Settings(justMemorize: justMemorize, currentView: $currentView)
                .transition(.opacity)
                .background(Color("JMBlack"))
        }
    }
    
    enum viewState {
        case mainMenu
        case versePreview
        case quizView
        case results
        case instructions
        case settings
    }
    
}

struct JustMemorizeView_Previews: PreviewProvider {
    static var previews: some View {
        let justMemorize = JustMemorize(difficulty: "Easy", reference: Reference(), input: "Typing", toggleVerse: true, toggleTimer: true)
        JustMemorizeView(justMemorize: justMemorize, currentApp: .constant(.justMemorizeApp), toggleVerse: .constant(true), toggleTimer: .constant(true))
            .environmentObject(SwordMinder())
    }
}
