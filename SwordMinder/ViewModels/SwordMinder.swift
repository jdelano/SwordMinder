//
//  SwordMinder.swift
//  SwordMinder
//
//  Created by John Delano on 10/7/22.
//

import Foundation


/// The SwordMinder view model class
class SwordMinder: ObservableObject {
    typealias Armor = Player.Armor
    typealias ArmorPiece = Player.Armor.ArmorPiece
    typealias Entry = Leaderboard.Entry
        
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
    
    // Passage loading state (used by PassagePickerView)
    @Published var currentPassageText: String = ""
    @Published var passageLoadError: Error?
    @Published var isLoadingPassage: Bool = false
    
    private var passageLoadTask: Task<Void, Never>? = nil
    
    @MainActor
    func loadPassageText(for passage: Passage, debounceDelay: UInt64 = 300_000_000) {
        passageLoadTask?.cancel()
        
        passageLoadTask = Task {
            // Debounce: gives time for pickers to settle
            try? await Task.sleep(nanoseconds: debounceDelay)
            
            guard !Task.isCancelled else {
                print("🟡 Passage load cancelled before start")
                return
            }
            
            isLoadingPassage = true
            passageLoadError = nil
            
            do {
                let text = try await passage.text()
                currentPassageText = text
            } catch {
                if !(error is CancellationError) {
                    passageLoadError = error
                    currentPassageText = ""
                } else {
                    print("🟡 Passage load was cancelled mid-flight")
                }
            }
            
            isLoadingPassage = false
        }
    }
    
    
    /// SwordMinder initializer
    /// - Parameters:
    ///   - translation: The bible translation to use for the game; defaults to KJV
    ///   - player: The player object to use for the game; defaults to a new Player object
    ///   - leaderboard: The leaderboard to use for the game; defaults to a new Leaderboard object
    init(player: Player = Player(), leaderboard: Leaderboard = Leaderboard()) {
//        if let url = Autosave.playerURL,
//           let savedPlayer = try? Player(url: url) {
//            self.player = savedPlayer
//        } else {
            self.player = player
//        }
        if let url = Autosave.leaderboardURL, let savedLeaderboard = try? Leaderboard(url: url) {
            self.leaderboard = savedLeaderboard
        } else {
            self.leaderboard = leaderboard
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
    
    /// Saves player data to the specified URL
    /// - Parameter url: The `URL` to save the player data to
    private func savePlayer(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            // Make sure SwordMinder folder exists
            try verifySwordMinderFolder()
            let playerData: Data = try player.json()
            try playerData.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) couldn't encode Player as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisFunction) error = \(error)")
        }
    }

    
    /// Saves the leaderboard data to the specified URL
    /// - Parameter url: The `URL` to save the leaderboard data to
    private func saveLeaderboard(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            try verifySwordMinderFolder()
            let leaderboardData: Data = try leaderboard.json()
            try leaderboardData.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) couldn't encode Leaderboard as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisFunction) error = \(error)")
        }
    }

    
    /// Verifies the creation of the SwordMinder folder in the application support directory; if not created, this method will create it
    private func verifySwordMinderFolder() throws {
        if let smFolderUrl = Autosave.swordMinderFolder, !FileManager.default.fileExists(atPath: Autosave.swordMinderFolderName) {
            try FileManager.default.createDirectory(at: smFolderUrl, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // MARK: - Player Intent
    
    /// Indicates whether or not a player is eligible to receive a reward for completing a task
    var taskEligible: Bool {
        player.eligible
    }
    
    func armor(piece: ArmorPiece) -> Armor {
        guard let index = player.armor.firstIndex(where: { $0.piece == piece }) else {
            return .init(piece: piece, material: .linen)
        }
        return player.armor[index]
    }
       
    /// Complete a user task
    /// - Parameter difficulty: The level of difficulty of the task on a scale of 1 to 5. Values outside this range will be ignored.
    func completeTask(difficulty: Int) {
        player.reward(gems: difficulty)
    }
    
    /// The Bible passages that the user has selected to focus on for engagement
    var passages: [Passage] {
        player.passages
    }
    
    /// Add a passage to the user's list of selected passages
    /// - Parameter passage: The `Passage` object that should be added
    func addPassage(_ passage: Passage) {
        player.addPassage(passage)
    }
    
    /// Removes the passages from the user's list of selected passages at the specified offset indices
    /// - Parameter offsets: The offset indices at which to remove the user's passages.
    func removePassages(atOffsets offsets: IndexSet) {
        player.removePassages(atOffsets: offsets)
    }

    
    /// Mark the specified passage as having been reviewed
    /// - Parameter passage: The `Passage` that has been reviewed
    func reviewPassage(_ passage: Passage) {
        player.reviewPassage(passage)
    }
    
    
    /// Indicates whether the player has reviewed the specified passage the minimum number of times since midnight of the current date
    /// - Parameter passage: The `Passage` that has been reviewed
    /// - Returns: A `Bool` indicated whether or not the user has reviewed the specified passage the minimum number of times today.
    func isPassageReviewedToday(_ passage: Passage) -> Bool {
        player.passageReviewedToday(passage)
    }
        
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
