//
//  SwordMinderView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

enum Apps {
    case swordMinder
    case sampleApp
    case wordSearchApp
    case justMemorizeApp
}


struct SwordMinderView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @State var currentApp: Apps = .swordMinder
    
    var body: some View {
        switch currentApp {
            case .swordMinder: swordMinderMainView
            case .sampleApp: SampleAppView(currentApp: $currentApp)
            case .wordSearchApp: WordSearchView(wordSearch: WordSearch(), currentApp: $currentApp, passage: swordMinder.passages.randomElement() ?? Passage())
            case .justMemorizeApp: JM_MainMenu(justMemorize: JustMemorize(), currentApp: $currentApp)
        }
    }

    var swordMinderMainView : some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage:"house")
                }
            MemorizeView()
                .tabItem {
                    Label("Memorize", systemImage: "brain")
                }
            GameView(currentApp: $currentApp)
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                }
            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "list.star")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        SwordMinderView()
            .environmentObject(SwordMinder())
    }
}
