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
    
    @Published var bible: Bible
    @Published var player: Player {
        didSet {
            if let url = Autosave.playerURL {
                savePlayer(to: url)
            }
        }
    }
    @Published var leaderboard: Leaderboard {
        didSet {
            if let url = Autosave.leaderboardURL {
                saveLeaderboard(to: url)
            }
        }
    }

    var isLoaded: Bool {
        bible.isLoaded
    }

    init(translation: Bible.Translation = .kjv, player: Player = Player(), leaderboard: Leaderboard = Leaderboard()) {
        if let url = Autosave.playerURL, let savedPlayer = try? Player(url: url) {
            self.player = savedPlayer
        } else {
            self.player = player
        }
        if let url = Autosave.leaderboardURL, let savedLeaderboard = try? Leaderboard(url: url) {
            self.leaderboard = savedLeaderboard
        } else {
            self.leaderboard = leaderboard
        }
        self.bible = Bible(translation: translation)
        Task { @MainActor in
            await bible.loadBible()
        }
    }
           
    // MARK: - Persistence
        
    private struct Autosave {
        static let swordMinderFolderName = "org.thedigitalpath.swordminder"
        static let playerFileName = "Player.swordminder"
        static let leaderboardFileName = "Leaderboard.swordminder"
        static var appSupportSubDirectory: URL? {
            FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        }
        static var swordMinderFolder: URL? {
            return appSupportSubDirectory?.appendingPathComponent(swordMinderFolderName, isDirectory: true)
        }
        static var playerURL: URL? {
            return swordMinderFolder?.appendingPathComponent(playerFileName)
        }
        static var leaderboardURL: URL? {
            return swordMinderFolder?.appendingPathComponent(leaderboardFileName)
        }
    }
        
    private func savePlayer(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            if !FileManager.default.fileExists(atPath: Autosave.playerFileName), let url = Autosave.swordMinderFolder {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            let playerData: Data = try player.json()
            try playerData.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) couldn't encode Player as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisFunction) error = \(error)")
        }
    }

    private func saveLeaderboard(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            let leaderboardData: Data = try leaderboard.json()
            try leaderboardData.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) couldn't encode Leaderboard as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisFunction) error = \(error)")
        }
    }

    
    // MARK: - Player Intent
    
    var taskEligible: Bool {
        player.eligible
    }
    
    func completeTask(difficulty: Int) {
        player.reward(gems: difficulty)
    }
    
    func armorLevel(piece: ArmorPiece) -> Int {
        player.armor.first(where: { $0.piece == piece })?.level ?? 1
    }

    var passages: [Passage] {
        player.passages
    }
    
    func addPassage(_ passage: Passage) {
        player.addPassage(passage)
    }
    
    func removePassages(atOffsets offsets: IndexSet) {
        player.removePassages(atOffsets: offsets)
    }

    func reviewPassage(_ passage: Passage) {
        player.reviewPassage(passage)
    }
    
    func isPassageReviewedToday(_ passage: Passage) -> Bool {
        player.passageReviewedToday(passage)
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
