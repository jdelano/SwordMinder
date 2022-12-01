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
    @EnvironmentObject var swordMinder: SwordMinder
    @State var currentApp: Apps = .swordMinder
    
    
    var body: some View {
        switch currentApp {
            case .swordMinder: swordMinderMainView
            case .sampleApp: SampleAppView(currentApp: $currentApp)
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
            .environmentObject(SwordMinder(player: Player(withArmor: [
                Player.Armor(level: 30, piece: .helmet),
                Player.Armor(level: 30, piece: .breastplate),
                Player.Armor(level: 30, piece: .belt),
                Player.Armor(level: 30, piece: .shoes),
            ], armorMaterial: .linen, gems: 100)))
    }
}
