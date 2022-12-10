//
//  WheelOfProvidence.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import Foundation

class WheelOfProvidence: ObservableObject {
    var verse: String = ""
    var guessedLetter: String?
    var guessedPhrase: String?
    var wheel: PieWheel
    var grid = [LetterTile]()
    var score = 1000
    var award = 1
    var spinDouble = 0.0
    
    init() {
        self.guessedLetter = nil
        self.guessedPhrase = nil
        self.wheel = PieWheel(text1: "1 Gem", text2: "2 Gems", text3: "3 Gems", text4: "4 Gems", isSpun: false)
    }

    
    func containsGuessedLetter() -> Bool {
        verse.contains(guessedLetter ?? "1")
    }
    
    func guessedPhraseIsCorrect() -> Bool {
        verse == guessedPhrase
    }
    
    func spinWheel(){
        spinDouble = Double.random(in: 0.0 ..< 4.0)
        award = Int(spinDouble.rounded())
    }
    
    func guessLetter(guess: String) {
        guessedLetter = guess
        score -= 50
    }
    
    func guessPhrase(guess: String) {
        guessedPhrase = guess
    }
    
    func createGrid(verse: String) {
        for i in verse{
            grid.append(LetterTile(letter: i))
        }
    }
    
    func updateGrid(_ guess: String) {
        for (tile, _) in grid.enumerated() {
            if(grid[tile].letter == Character(guess)){
                grid[tile].flip()
            }
        }
    }
}
