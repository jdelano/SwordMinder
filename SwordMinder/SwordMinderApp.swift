//
//  SwordMinderApp.swift
//  SwordMinder
//
//  Created by John Delano on 6/17/22.
//

import SwiftUI

@main
struct SwordMinderApp: App {
    @StateObject var swordMinder = SwordMinder(player: Player(withArmor: [
        Player.Armor(level: 30, piece: .helmet),
        Player.Armor(level: 30, piece: .breastplate),
        Player.Armor(level: 30, piece: .belt),
        Player.Armor(level: 30, piece: .shoes),
    ], armorMaterial: .linen, gems: 5000))
    var body: some Scene {
        WindowGroup {
            SwordMinderView()
                .environmentObject(swordMinder)
        }
    }
}
