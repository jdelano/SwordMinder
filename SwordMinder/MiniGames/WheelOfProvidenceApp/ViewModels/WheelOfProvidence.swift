//
//  WheelOfProvidence.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import Foundation

class WheelOfProvidence: ObservableObject {
    var verse: String = ""
    var verseList: [Verse]
    var guessedLetter: String?
    var guessedPhrase: String?
    var wheel: PieWheel
    
    init(verseList: [Verse], guessedLetter: String? = nil, guessedPhrase: String? = nil) {
        self.verseList = verseList
        self.guessedLetter = guessedLetter
        self.guessedPhrase = guessedPhrase
        self.wheel = PieWheel(ref1: verseList[0].reference.toString(), ref2: verseList[1].reference.toString(), ref3: verseList[2].reference.toString(), ref4: verseList[3].reference.toString(), isSpun: false)
    }

    
    func containsGuessedLetter() -> Bool {
        verse.contains(guessedLetter ?? "1")
    }
    
    func guessedPhraseIsCorrect() -> Bool {
        verse == guessedPhrase
    }
    
    func selectVerse(num: Double) {
        if num < 1 {verse = verseList[0].text}
        else if num < 2 {verse = verseList[1].text}
        else if num < 3 {verse = verseList[2].text}
        else {verse = verseList[3].text}
    }
    
    func wheelSpinDouble() -> Double{
        return Double.random(in: 0.0 ..< 4.0)
    }
}
