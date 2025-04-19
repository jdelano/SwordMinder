//
//  WordSearchGame.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import Foundation

class WSLabel {
    var tile: Tile = Tile(letter: " ")
}

class WordSearchGame : ObservableObject {
    /// Initial word list
    var words = [Word]()
    var gridSize = 10
    private var labels = [[WSLabel]]()
    @Published var foundPipes = [Pipe]()
    @Published var timers = [Timer]()
    @Published var timeRemaining: Int = 0
    @Published var game: WordSearch {
        didSet {
            if let url = Autosave.wordSearchPreferencesURL {
                savePreferences(to: url)
            }
        }
    }
    
    var difficulty: Difficulty {
        get {
            game.difficulty
        }
        set {
            game.difficulty = newValue
            makeGrid()
        }
    }
    
    var showTutorial: Bool {
        get {
            game.showTutorial
        }
        set {
            game.showTutorial = newValue
        }
    }
    
    var difficultyMultipler: Int {
        difficulty == .easy ? 1 : difficulty == .medium ? 3 : 5
    }

    var totalTime: Int {
        60 * difficultyMultipler + (wordsUsed.count > 5 ? wordsUsed.count * 5 : 0)
    }
    
    private let allLetters = (65...90).map { Character(UnicodeScalar($0)) }
    @Published var grid = [[Tile]]()
    @Published var wordsUsed = [Word]()
    
    var won: Bool {
        wordsUsed.allSatisfy { $0.found }
    }
    
    // MARK: - Persistence

    private struct Autosave {
        static let wordSearchFolderName = "org.thedigitalpath.swordminder.wordsearch"
        static var appSupportSubDirectory: URL? {
            FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        }
        static var wordSearchFolderURL: URL? {
            return appSupportSubDirectory?.appendingPathComponent(wordSearchFolderName, isDirectory: true)
        }
        static var wordSearchPreferencesURL: URL? {
            return wordSearchFolderURL?.appendingPathComponent(wordSearchFolderName)
        }
    }
    
    
    /// Saves the leaderboard data to the specified URL
    /// - Parameter url: The `URL` to save the leaderboard data to
    private func savePreferences(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            try verifyWordSearchFolder()
            let wordSearchPreferences: Data = try JSONEncoder().encode(game)
            try wordSearchPreferences.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) couldn't encode Leaderboard as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisFunction) error = \(error)")
        }
    }
    
    
    /// Verifies the creation of the SwordMinder folder in the application support directory; if not created, this method will create it
    private func verifyWordSearchFolder() throws {
        if let wsFolderUrl = Autosave.wordSearchFolderURL, !FileManager.default.fileExists(atPath: Autosave.wordSearchFolderName) {
            try FileManager.default.createDirectory(at: wsFolderUrl, withIntermediateDirectories: true, attributes: nil)
        }
    }

    // MARK: - Initializer
    init() {
        if let url = Autosave.wordSearchPreferencesURL,
            let savedPreferencesData = try? Data(contentsOf: url),
           let savedPreferences = try? JSONDecoder().decode(WordSearch.self, from: savedPreferencesData) {
            self.game = savedPreferences
        } else {
            self.game = WordSearch()
        }
    }
    
    // MARK: - Grid functionality
    
    /// Generates the grid based on the words array
    func makeGrid() {
        labels = (0..<gridSize).map { _ in
            (0..<gridSize).map { _ in
                WSLabel()
            }
        }
        wordsUsed = placeWords()
            .removingDuplicates(for: { $0.text.uppercased() })
            .sorted(by: { $0.text.uppercased() < $1.text.uppercased() })
        fillGaps()
        updateGrid()
    }
    
    
    private func fillGaps() {
        for column in labels {
            for label in column {
                if label.tile.letter == " " {
                    label.tile.letter = allLetters.randomElement()!
                }
            }
        }
    }
    
    
    private func updateGrid() {
        if labels.endIndex >= gridSize {
            grid = (0..<gridSize).map { row in
                (0..<gridSize).map { col in
                    labels[row][col].tile
                }
            }
        }
    }
        
    
    private func labels(fromX x: Int, y: Int, word: String, movement: (x: Int, y: Int)) -> [WSLabel]? {
        var returnValue = [WSLabel]()
        
        var xPosition = x
        var yPosition = y
        
        for letter in word {
            let label = labels[xPosition][yPosition]
            
            if label.tile.letter == " " || label.tile.letter == letter {
                returnValue.append(label)
                xPosition += movement.x
                yPosition += movement.y
            } else {
                return nil
            }
        }
        
        return returnValue
    }
    
    
    private func tryPlacing(_ word: String, movement: (x: Int, y: Int)) -> Bool {
        let xLength = (movement.x * (word.count - 1))
        let yLength = (movement.y * (word.count - 1))
        
        let rows = (0 ..< gridSize).shuffled()
        let cols = (0 ..< gridSize).shuffled()
        
        for row in rows {
            for col in cols {
                let finalX = col + xLength
                let finalY = row + yLength
                
                if finalX >= 0 && finalX < gridSize && finalY >= 0 && finalY < gridSize {
                    if let returnValue = labels(fromX: col, y: row, word: word, movement: movement) {
                        for (index, letter) in word.enumerated() {
                            returnValue[index].tile.letter = letter
                            returnValue[index].tile.associatedWords.append(word)
                        }
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func place(_ word: Word) -> Bool {
        let formattedWord = word.text.replacingOccurrences(of: " ", with: "").uppercased()
        
        return difficulty.placementTypes.contains {
            tryPlacing(formattedWord, movement: $0.movement)
        }
    }
    
    private func placeWords() -> [Word] {
        words.shuffled().filter(place)
    }

    // MARK: - User Intent Functions
    
    
    /// Starts the word search game
    /// - Parameter passage: The passage to use for the word search game
    func startGame(passage: Passage, outOfTime: @escaping (Timer)->Void) {
        Task { @MainActor in
            let tempPassage = passage
            words = (try? await tempPassage.words()
                .unique()
                .filter { $0.count > 3 }
                .map { Word(text: $0) }) ?? []
            makeGrid()
            foundPipes.removeAll()
            startTimer(finished: outOfTime)
        }
    }

    func startTimer(finished: @escaping (Timer)->Void) {
        timeRemaining = totalTime
        timers.append(Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timeRemaining -= 1
            if self.timeRemaining == 0 {
                finished(timer)
                timer.invalidate()
            }
        })
    }
    
    func stopAllTimers() {
        timers.forEach({ timer in
            timer.invalidate()
        })
    }

//    func endGame(timeRemaining: Int) -> GameResult {
//        
//    }
    
    /// Mark the specified word found in the wordsUsed list
    /// - Parameter word: The `Word` to be marked found
    func markWordFound(_ word: Word) {
        if let index = wordsUsed.index(matching: word) {
            wordsUsed[index].found = true
        }
    }

    func addPipe(start: (row: Int, col: Int), end: (row: Int, col: Int)) {
        let pipe = Pipe(startRow: start.row, startCol: start.col, endRow: end.row, endCol: end.col, found: true)
        foundPipes.append(pipe)
        timers.append(Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
            self.foundPipes[pipe].new = false
        })
    }
    
    
    /// Retrieves the `Tile`s that are associated with the specified word
    /// - Parameter word: A string representation of the word, case-insensitive
    /// - Returns: An Array of `Tile`s
    func tilesForWord(_ word: String) -> [Tile] {
        var tiles = [Tile]()
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col].associatedWords.contains(word.uppercased()) {
                    tiles.append(grid[row][col])
                }
            }
        }
        return tiles
    }
    
    /// Retrieves an array of `Tile`s that lie on the horizontal, vertical, or diagonal line that most nearly connects the start and end points
    /// - Parameters:
    ///   - startPoint: The (row,col) tuple that defines the start of the line
    ///   - endPoint: The (row,col) tuple that defines the end of the line
    /// - Returns: An array of `Tile`s that lie on the line
    func tilesInLine(from startPoint: (row: Int, col: Int), to endPoint: (row: Int, col: Int)) -> [Tile] {
        let deltaCol = endPoint.col - startPoint.col
        let deltaRow = endPoint.row - startPoint.row
        let stepCol = deltaCol > 0 ? 1 : -1
        let stepRow = deltaRow > 0 ? 1 : -1
        
        if deltaCol == 0 {
            return stride(from: startPoint.row, through: endPoint.row, by: stepRow)
                .map({ grid[$0][startPoint.col] })
        }
        
        if deltaRow == 0 {
            return stride(from: startPoint.col, through: endPoint.col, by: stepCol)
                .map({ grid[startPoint.row][$0] })
        }
        
        var tiles: [Tile] = []
        if abs(deltaCol) > abs(deltaRow) {
            var row = startPoint.row
            for col in stride(from: startPoint.col, through: endPoint.col, by: stepCol) {
                if row >= 0 && row < gridSize && col >= 0 && col < gridSize  {
                    tiles.append(grid[row][col])
                    row += stepRow
                }
            }
        } else {
            var col = startPoint.col
            for row in stride(from: startPoint.row, through: endPoint.row, by: stepRow) {
                if row >= 0 && row < gridSize && col >= 0 && col < gridSize  {
                    tiles.append(grid[row][col])
                    col += stepCol
                }
            }
        }
        return tiles
    }
    
    
    enum GameResult : Codable {
        case loss(points: Int)
        case win(points: Int)
        
        var points: Int {
            switch self {
                case .loss(let points): return points
                case .win(let points): return points
            }
        }
    }
}
