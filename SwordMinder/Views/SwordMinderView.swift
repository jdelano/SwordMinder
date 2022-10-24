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
}


struct SwordMinderView: View {
    @ObservedObject var swordMinder: SwordMinder
    @State var currentApp: Apps = .swordMinder
    
    
    var body: some View {
        switch currentApp {
            case .swordMinder: swordMinderMainView
            case .sampleApp: SampleAppView(currentApp: $currentApp)
        }
    }

    var swordMinderMainView : some View {
        TabView {
            HomeView(swordMinder: swordMinder)
                .tabItem {
                    Label("Home", systemImage:"house")
                }
            MemorizeView(swordMinder: swordMinder)
                .tabItem {
                    Label("Memorize", systemImage: "brain")
                }
            GameView(currentApp: $currentApp)
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                }
            LeaderboardView(swordMinder: swordMinder)
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
        SwordMinderView(swordMinder: SwordMinder(player: Player(withArmor: [], gems: 5000), leaderboard: Leaderboard(entries: [
            SwordMinder.Entry(app:"Bible Trivia", score: 500),
            SwordMinder.Entry(app:"Bible Tetris", score: 1000),
            SwordMinder.Entry(app:"Speak'n'Say", score: 1500),
            SwordMinder.Entry(app:"Talk it Out", score: 250),
            SwordMinder.Entry(app:"Block Book", score: 100)
        ])))
    }
}
