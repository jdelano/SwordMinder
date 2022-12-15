//
//  JustMemorize.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/11/22.
//

import SwiftUI

class JustMemorize: ObservableObject {
    
    @State var verseReference: Reference
    @EnvironmentObject var swordMinder: SwordMinder
    
    typealias settings = JMSettingsModel
    //typealias Verse = JMReference.reference
//    @Published private var verse: JMVerse
    
    @Published var selectedDifficulty: String
    //@Published var selectedInput: String
    @Published var toggleVerse: Bool
    @Published var toggleTimer: Bool
    
    var difficulties = ["Easy", "Medium", "Hard"]
    
    var inputTypes = ["Dictation", "Typing"]
    
    var reference: String {
        verseReference.toString()
    }
    var verse: String {
        swordMinder.bible.text(for: verseReference)
    }
    var verseArray: [String] {
        verse.map { String($0) }
    }
    var referenceArray: [String] {
        reference.map { String($0) }
    }
    
    init(difficulty: String, reference: Reference, /*input: String,*/ toggleVerse: Bool, toggleTimer: Bool) {
        self.verseReference = reference
        self.selectedDifficulty = difficulty
        //self.selectedInput = input
        self.toggleVerse = toggleVerse
        self.toggleTimer = toggleTimer
    }
//    private mutating func createJustMemorizeGame() {
//    }
    
    
    //MARK: Intent
    
    ///This func accepts a string and returns a double of the relevant difficulty multiplier.
    func difficultyModifier(difficulty: String) -> Double {
        switch difficulty {
            case "Easy":
                return 0.15
            case "Medium":
                return 0.5
            case "Hard":
                return 1
            default:
                return 0.15
        }
    }
    
//    /// This func accepts a reference and returns a string of the reference.
//    func reference(reference: Reference) -> String {
//        Verse.verseReference.toString()
//    }
}
