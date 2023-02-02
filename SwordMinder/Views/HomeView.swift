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
    
    var body: some View {
        Image(verticalSizeClass == .regular ? "HomeBackground" : "HomeBackgroundLandscape")
            .resizable()
            .ignoresSafeArea(edges: [.top, .leading, .trailing])
            .overlay(
                VStack {
                    if verticalSizeClass == .regular {
                        levelAndGem
                        Spacer()
                    }
                    HStack(alignment: .bottom) {
                        if verticalSizeClass == .compact {
                            levelAndGem
                        }
                        character
                        VStack(spacing: 0) {
                            ForEach(swordMinder.player.armor) { armor in
                                ArmorUpgradeView(currentLevel: armor.level,
                                                 upgradeCost: armor.costToLevelUp(),
                                                 imageName: armor.imageName,
                                                 enabled: swordMinder.player.canLevelUp(armorPiece: armor.piece)) {
                                    withAnimation {
                                        swordMinder.player.levelUp(piece: armor.piece)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color("AliceBlue").opacity(0.8))
                    }
                }
                .clipped()
            )
    }
    
    
    private var levelAndGem: some View {
        HStack {
            Spacer()
            Text("Level: \(swordMinder.player.level)")
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(.white)
            Spacer()
            GemView(amount: swordMinder.player.gems)
                .frame(width: 40, height: 40)
            Spacer()
        }
        .padding()
    }
    
    private var character: some View {
        VStack {
            SMButtonView(caption: "Upgrade", glyph: {
                GemView(amount: 0)
                    .frame(width: 25, height: 25)
            }) {
                swordMinder.player.upgradeArmor()
            }
            .padding()
            .opacity(swordMinder.player.canUpgradeArmorMaterial ? 1 : 0)
            Image(swordMinder.player.imageName)
                .resizable()
                .aspectRatio(0.35, contentMode: .fit)
                .frame(maxWidth: 175, alignment: .bottom)
                .padding()
        }
    }
    
    private struct DrawingConstants {
        static let castleScalingFactor: CGFloat = 1/3
        static let castleXLocationScale: CGFloat = 3/4
        static let castleYLocationScale: CGFloat = 1/4
        static let skyHeightProportion: CGFloat = 1/4
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SwordMinder(player: Player(withArmor: [
                Player.Armor(level: 40, piece: .helmet),
                Player.Armor(level: 40, piece: .breastplate),
                Player.Armor(level: 40, piece: .belt),
                Player.Armor(level: 40, piece: .shoes),
            ], armorMaterial: .leather, gems: 999)))
    }
}

