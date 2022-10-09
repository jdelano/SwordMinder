//
//  Player.swift
//  Player
//
//  Created by John Delano on 10/8/22.
//

import Foundation

struct Player {
    
    private(set) var gems: Int = 0
    var passages: [Bible.Passage] = []
    
    var helmet: Armor = Armor(material: .damascusSteel)
    var breastPlate: Armor
    var belt: Armor
    var shoes: Armor
    
    struct Armor {
        var material: ArmorMaterial
        var level: Int = 1
        
        
        enum ArmorMaterial {
            case linen
            case leather
            case damascusSteel
            case gem
        }
    }
    
    mutating func addGems(_ gems: Int) {
        if gems >= 1 && gems <= 5 {
            self.gems += gems
        }
    }
}
