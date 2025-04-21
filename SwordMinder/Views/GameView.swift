//
//  GameView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct GameView: View {
    @Binding var currentApp: Apps
    
    var body: some View {
        ScrollView {
            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                GridRow {
                    AppIconView(title: "Word Find", iconImageName: "WordFindIcon") {
                        withAnimation {
                            currentApp = .wordSearchApp
                        }
                    }
                    AppIconView(title: "Memory Tile", iconImageName: "MemoryTileIcon") {
                        withAnimation {
                            currentApp = .memoryTileApp
                        }
                    }

                }
                GridRow {
                    AppIconView(title: "Wheel of Providence", iconImageName: "WheelOfProvidenceIcon") {
                        withAnimation {
                            currentApp = .wheelOfProvidenceApp
                        }
                    }
                    AppIconView(title: "Flappy Memory", iconImageName: "FlappyMemoryIcon") {
                        withAnimation {
                            currentApp = .flappyMemoryApp
                        }
                    }

                }
            }
            .padding()
        }
    }
}

#Preview {
    GameView(currentApp: .constant(.swordMinder))
}
