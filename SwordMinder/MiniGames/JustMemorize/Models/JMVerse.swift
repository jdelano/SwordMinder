//
//  JMVerse.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/13/22.


import SwiftUI

struct JMVerse {
    @EnvironmentObject var swordMinder: SwordMinder
    @State var verseReference: Reference
    private(set) var verseArray: Array<Word>
    
    let lowerCase: Set<Character> = Set("qwertyuiopasdfghjklzxcvbnm")
    let upperCase: Set<Character> = Set("QWERTYUIOPASDFGHJKLZXCVBNM")

//    private var indexOfTheWord: Int? {
//        get {}
//        set {}
//    }
    
    //adapted from Andrew Wordhouse
    struct Word: Identifiable {
        let id = UUID()
        let order: Int
        let word: String
        var isCorrect = true
    }
    
    struct blank {
        var text: String
        let order: Int
    }
    
//    mutating func toArray(reference: Reference) -> Array<Word> {
//        let array = (swordMinder.bible.text(for: verseReference)).components(separatedBy: " ")
//    }
    

//    init(verseReference: Reference) {
//        verseArray = Array<Word>()
//        for Word in 0...<
//    }
}

struct JMReference {
    @State var verseReference: Reference
    @EnvironmentObject var swordMinder: SwordMinder
    
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
}
