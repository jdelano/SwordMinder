//
//  SwordMinder.swift
//  SwordMinder
//
//  Created by John Delano on 10/7/22.
//

import Foundation

class SwordMinder: ObservableObject {
    @Published var bible: Bible
    @Published var player: Player
    @Published var leaderboard: Leaderboard
    
    init() {
        self.bible = Bible(translation: .kjv, url: Bundle.main.url(forResource: "kjv", withExtension: "json")!)
        self.player = Player(breastPlate: .init(material: .damascusSteel), belt: .init(material: .damascusSteel), shoes: .init(material: .damascusSteel))
        self.leaderboard = Leaderboard()
    }
    
    
    
    // MARK: - Intent
    
    func completeTask(difficulty: Int) {
        player.addGems(difficulty)
    }
}
