//
//  SwordMinderView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct SwordMinderView: View {
    @ObservedObject var swordMinder: SwordMinder
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage:"house")
                }
            MemorizeView(bibleVM: swordMinder)
                .tabItem {
                    Label("Memorize", systemImage: "brain")
                }
            GameView()
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            Text("More")
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }

        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        SwordMinderView(swordMinder: SwordMinder())
    }
}
