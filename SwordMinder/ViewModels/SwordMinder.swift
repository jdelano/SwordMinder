//
//  SwordMinder.swift
//  SwordMinder
//
//  Created by John Delano on 10/7/22.
//

import Foundation

class SwordMinder: ObservableObject {
    typealias ArmorPiece = Player.Armor.ArmorPiece
    typealias Entry = Leaderboard.Entry
    typealias Passage = Bible.Passage
    typealias Reference = Bible.Reference
    typealias Book = Bible.Book
    
    @Published var bible: Bible
    @Published var player: Player
    @Published var leaderboard: Leaderboard

    var isLoaded: Bool {
        bible.isLoaded
    }

    init(translation: Bible.Translation = .kjv, player: Player = Player(), leaderboard: Leaderboard = Leaderboard()) {
        self.player = player
        self.leaderboard = leaderboard
        self.bible = Bible(translation: translation)
        Task { @MainActor in
            await bible.initBible()
        }
    }
               
    // MARK: - Player Intent
    
    func completeTask(difficulty: Int) {
        player.reward(gems: difficulty)
    }
    
    func armorLevel(piece: ArmorPiece) -> Int {
        player.armor.first(where: { $0.piece == piece })?.level ?? 1
    }

    var passages: [Passage] {
        player.passages
    }
    
    func addPassage(from startReference: String, to endReference: String? = nil) {
        if let passage = bible.passage(fromString: startReference, toString: endReference) {
            player.addPassage(passage)
        }
    }
    
    func removePassages(atOffsets offsets: IndexSet) {
        player.removePassages(atOffsets: offsets)
    }

    
    // MARK: - Bible Intent
    
    
    
    
    // MARK: - Leaderboard Intent
    
    /// Contains an array of Leaderboard.Entry objects sorted in descending order by score
    var highScoreEntries: [Entry] {
        leaderboard.entries.sorted(by: { $0.score > $1.score })
    }
    
    /// Adds or updates a high score entry into the leaderboard
    ///
    /// If app exists in the leaderboard, the score of the existing entry for the app will be updated.
    /// If the app does not exist in the leaderboard, an Entry will be created for the app name and associated score
    /// - Parameters:
    ///   - app: The name of the app to put on the leaderboard
    ///   - score: The high score to associate with the app
    func highScore(app: String, score: Int) {
        if let index = leaderboard.entries.firstIndex(where: { $0.app == app }) {
            leaderboard.update(index: index, score: score)
        } else {
            leaderboard.add(app: app, score: score)
        }
    }
    
}
