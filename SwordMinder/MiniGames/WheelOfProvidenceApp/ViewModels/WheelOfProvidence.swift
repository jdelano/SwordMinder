//
//  WheelOfProvidence.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import Foundation

class WheelOfProvidence: ObservableObject {
    var words = [String]()
    var verse: String = ""
    var guessedLetter: String?
    var guessedPhrase: String?
    @Published var wheel: PieWheel
    var grid = [LetterTile]()
    var score = 1000
    var award = 1
    var spinDouble = 0.0
    
    init() {
        self.guessedLetter = nil
        self.guessedPhrase = nil
        self.wheel = PieWheel(text1: "4 Gems", text2: "3 Gems", text3: "2 Gems", text4: "1 Gem", isSpun: false)
    }

    
    func containsGuessedLetter() -> Bool {
        verse.localizedCaseInsensitiveContains(guessedLetter ?? "1")
    }
    
    func guessedPhraseIsCorrect() -> Bool {
        verse.caseInsensitiveCompare(guessedPhrase ?? "1") == .orderedSame
    }
    
    func spinWheel(){
        spinDouble = Double.random(in: 0.125..<1.125)
        award = Int((spinDouble*4.0).rounded())
        wheel.isSpun = true
    }
    
    func guessLetter(_ guess: String) {
        guessedLetter = guess
        score -= 50
    }
    
    func guessPhrase(guess: String) {
        guessedPhrase = guess
    }
    
    func createGrid(verse: String) {
        for i in verse{
            if(true){
                grid.append(LetterTile(letter: i))
            }
        }
    }
    
    func updateGrid(_ guess: String) {
        for (tile, _) in grid.enumerated() {
            if(String(grid[tile].letter).caseInsensitiveCompare(guess) == .orderedSame){
                grid[tile].flip()
            }
        }
    }
    
    func convertWordsToVerse() {
        for i in words {
            verse.append(i)
            verse.append(" ")
        }
        verse.removeLast()
    }
}
