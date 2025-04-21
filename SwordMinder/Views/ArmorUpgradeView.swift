//
//  ArmorUpgradeView.swift
//  SwordMinder
//
//  Created by John Delano on 10/20/22.
//

import SwiftUI

struct ArmorUpgradeView: View {
    var armor: Player.Armor
    var levelUpRequested: () -> Void
    var upgradeRequested: () -> Void
    private var isReadyToUpgrade: Bool {
        armor.level == Player.Constants.maxLevel
    }
    
    var body: some View {
        ZStack {
            let armorImage = Image(armor.assetName)
                .resizable()
                .scaledToFit()
            // Background with texture
            Image(.brownTextureBackground) // your textured brown background
                .resizable()
                .scaledToFill()
                .cornerRadius(6)
                .frame(width: 145, height: 200)
                .clipped()
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.armorCardBrown, lineWidth: 2)
                )
            VStack(spacing: 4) {
                Text("\(armor.description)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 1)
                    .padding(.top, 1)
                
                Text("Level \(armor.level)/\(Player.Constants.maxLevel)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                ZStack {
                    Ellipse()
                        .fill(.black.opacity(0.3))
                        .aspectRatio(1, contentMode: .fit)
                    // Ghosted background image
                    armorImage
                        .opacity(0.3)
                    
                    // Leveled portion
                    let location = 5 + (CGFloat(armor.level - 1) / 38) * (38 - 5)
                    armorImage
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .black, location: location / CGFloat(Player.Constants.maxLevel)),
                                    .init(color: .black.opacity(0), location: 0)
                                ]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                    
                    // Gold outline using the image itself as a mask
                    if isReadyToUpgrade {
                        armorImage
                            .foregroundColor(.yellow)
                            .overlay(
                                armorImage
                                    .foregroundColor(.orange)
                                    .blur(radius: 1)
                            )
                            .mask(armorImage)
                            .shadow(color: .yellow.opacity(0.7), radius: 6, x: 0, y: 0)
                    }
                }
                
                SMButtonView(title: isReadyToUpgrade ? "UPGRADE" : "LEVEL UP") {
                    if isReadyToUpgrade {
                        upgradeRequested()
                    } else {
                        levelUpRequested()
                    }
                }
                .padding([.horizontal, .bottom])
                
            }
            
            if armor.costToLevelUp() > 0 {
                VStack {
                    Spacer()
                    GemView(amount: armor.costToLevelUp())
                }
            }
        }
        .frame(width: 145, height: 200)
    }
}


#Preview {
    @Previewable @StateObject var swordMinder = SwordMinder(player: Player(gems: 9999))
    let armorPiece: Player.Armor.ArmorPiece = .shoes
    ArmorUpgradeView(armor: swordMinder.armor(piece: armorPiece), levelUpRequested: {
        swordMinder.player.levelUp(piece: armorPiece)
    }) {
        swordMinder.player.upgrade(piece: armorPiece)
    }
}

//#Preview(traits: .landscapeLeft) {
//    ArmorUpgradeView(currentLevel: 32, upgradeCost: 99, enabled: true, action: { })
//}
