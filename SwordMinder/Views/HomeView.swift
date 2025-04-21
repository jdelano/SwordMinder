//
//  HomeView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @State private var bootsLevel = 1
    @State private var helmetLevel = 1
    @State private var legArmorLevel = 1
    @State private var chestArmorLevel = 1
    @State private var gems = 100
    
    @State private var showPulse = false
    @Namespace private var animation
    
    var allEqualLevel: Bool {
        bootsLevel == helmetLevel &&
        helmetLevel == legArmorLevel &&
        legArmorLevel == chestArmorLevel
    }
    
    var body: some View {
        ZStack {
            Image(verticalSizeClass == .regular ? "HomeBackground" : "HomeBackgroundLandscape")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .top)

            Image(swordMinder.player.characterAssetName)
                .frame(height: 100)

            VStack {
                topHUD
                HStack {
                    Spacer()
                    ArmorUpgradeView(armor: swordMinder.armor(piece: .helmet)) {
                        swordMinder.player.levelUp(piece: .helmet)

                    } upgradeRequested: {
                        swordMinder.player.upgrade(piece: .helmet)
                    }

                    Spacer()
                    ArmorUpgradeView(armor: swordMinder.armor(piece: .breastplate)) {
                        swordMinder.player.levelUp(piece: .breastplate)

                    } upgradeRequested: {
                        swordMinder.player.upgrade(piece: .breastplate)

                    }
                    Spacer()
                }
                .padding(.top)
                Spacer()

                
                HStack {
                    Spacer()
                    ArmorUpgradeView(armor: swordMinder.armor(piece: .belt)) {
                        swordMinder.player.levelUp(piece: .belt)

                    } upgradeRequested: {
                        swordMinder.player.upgrade(piece: .belt)

                    }
                    Spacer()
                    ArmorUpgradeView(armor: swordMinder.armor(piece: .shoes)) {
                        swordMinder.player.levelUp(piece: .shoes)

                    } upgradeRequested: {
                        swordMinder.player.upgrade(piece: .shoes)

                    }
                    Spacer()
                }
                .padding(.bottom, 20)
            }
            .animation(.easeInOut, value: allEqualLevel)
        }
    }
    
    private var topHUD: some View {
        HStack(spacing: 200) {
            Label {
                Text("Level \(swordMinder.player.level)")
                    .font(.headline)
                    .foregroundColor(.white)
            } icon: {
                Image(systemName: "shield.fill")
                    .foregroundColor(.white)
            }
            GemView(amount: swordMinder.player.gems, fontSize: 20)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 4)
    }
    


}



#Preview {
    HomeView()
        .environmentObject(SwordMinder(player: Player(gems: 9999)))
}
