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
        ZStack {
            background
                .ignoresSafeArea(edges: [.top, .leading, .trailing])
            VStack {
                if verticalSizeClass == .regular {
                    levelAndGem
                }
                Spacer()
                Grid(alignment: .bottom) {
                    GridRow(alignment: .top) {
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
                        .background(Color.white.opacity(0.8))
                        .gridCellUnsizedAxes([.vertical])
                    }
                }
            }
        }
    }
    
    private var background: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(.blue)
                        .frame(height: geometry.size.height * DrawingConstants.skyHeightProportion)
                    Rectangle()
                        .fill(.green)
                }
                Text("🏰")
                    .font(.system(size: min(geometry.size.width, geometry.size.height) * DrawingConstants.castleScalingFactor))
                    .position(x: geometry.size.width * DrawingConstants.castleXLocationScale, y: geometry.size.height * DrawingConstants.castleYLocationScale)
            }
        }
    }
    
    private var levelAndGem: some View {
        HStack {
            Text("Level: \(swordMinder.player.level)")
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(.white)
            GemView(amount: swordMinder.player.gems)
                .frame(width: 50, height: 50)
        }
    }
    
    private var character: some View {
        VStack {
            Image(swordMinder.player.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.leading)
            SMButtonView(caption: "Upgrade", glyph: {
                GemView(amount: 0)
                    .frame(width: 35, height: 35)
            }) {
                swordMinder.player.upgradeArmor()
            }
            .padding()
            .opacity(swordMinder.player.canUpgradeArmorMaterial ? 1 : 0)
            
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
        ], gems: 5000)))
    }
}

