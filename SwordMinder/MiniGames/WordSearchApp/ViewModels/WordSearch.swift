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
    var labels = [[WSLabel]]()
    var difficulty = Difficulty.hard
    let allLetters = (65...90).map { Character(UnicodeScalar($0)) }
    @Published var grid = [[Tile]]()
    @Published var wordsUsed = [Word]()
    
    func makeGrid() {
        labels = (0..<gridSize).map { _ in
            (0..<gridSize).map { _ in
                WSLabel()
            }
        }
        wordsUsed = placeWords().removingDuplicates(for: { element in
            element.text.uppercased()
        }).sorted(by: { word1, word2 in
            word1.text.uppercased() < word2.text.uppercased()
        })
        fillGaps()
        updateGrid()
        printGrid()
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
    
    private func printGrid() {
        for column in labels {
            for row in column {
                print(row.tile.letter, terminator: "")
            }
            print("")
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

}
