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
        self.wheel = PieWheel(text1: "1 Gem", text2: "2 Gems", text3: "3 Gems", text4: "4 Gems", isSpun: false)
    }

    
    func containsGuessedLetter() -> Bool {
        verse.localizedCaseInsensitiveContains(guessedLetter ?? "1")
    }
    
    func guessedPhraseIsCorrect() -> Bool {
        if(verse.caseInsensitiveCompare(guessedPhrase ?? "1") == .orderedSame){
            return true
        }
        else{
            return false
        }
    }
    
    func spinWheel(){
        spinDouble = Double.random(in: 0.0 ..< 4.0)
        award = Int(spinDouble.rounded())
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
