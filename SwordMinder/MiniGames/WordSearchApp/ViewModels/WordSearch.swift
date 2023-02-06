//
//  WordSearch.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import Foundation

class WSLabel {
    var tile: Tile = Tile(letter: " ")
}

class WordSearch : ObservableObject {
    var words = [Word]()
    var gridSize = 10
    private var labels = [[WSLabel]]()
    @Published var difficulty = Difficulty.easy {
        didSet {
            makeGrid()
        }
    }
    
    private let allLetters = (65...90).map { Character(UnicodeScalar($0)) }
    @Published var grid = [[Tile]]()
    @Published var wordsUsed = [Word]()
    
    var won: Bool {
        wordsUsed.allSatisfy { $0.found }
    }
    
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
    
//    func toggleSelect(_ tile: Tile) {
//        for row in 0..<gridSize {
//            for col in 0..<gridSize {
//                if grid[row][col].id == tile.id {
//                    grid[row][col].selected.toggle()
//                }
//            }
//        }
//    }
//
//    func unSelect(_ tile: Tile) {
//        for row in 0..<gridSize {
//            for col in 0..<gridSize {
//                if grid[row][col].id == tile.id {
//                    grid[row][col].selected = false
//                }
//            }
//        }
//    }
    
    func coordinate(for tile: Tile) -> (Int, Int)? {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col].id == tile.id {
                    return (row, col)
                }
            }
        }
        return nil
    }
    
    func markWordFound(_ word: Word) {
        if let index = wordsUsed.index(matching: word) {
            wordsUsed[index].found = true
        }
    }
    
    
    
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
}
