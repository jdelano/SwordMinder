//
//  JMVerse.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/13/22.
//

import SwiftUI

struct JMVerse {
    private(set) var verseArray: Array<Word>
    
    //private var indexOfTheWord: Int?
    
    @State var verseReference: Reference
    @EnvironmentObject var swordMinder: SwordMinder
    
    struct Word: Identifiable {
        let id = UUID()
        let word: String
    }
//
//
//    var reference: String {
//        return verseReference.toString()
//    }
//    let verse: String
//
//    let verseArray: [String] = []
//    let referenceArray: [String] = []
//
//    init() {
//        self.reference = verseReference.toString()
//        self.verse = (swordMinder.bible.text(for: verseReference))
//        /// adapted from https://reactgo.com/swift-convert-string-to-array/
//        self.verseArray = verse.map { String($0) }
//        self.referenceArray = reference.map { String($0) }
//    }
}
