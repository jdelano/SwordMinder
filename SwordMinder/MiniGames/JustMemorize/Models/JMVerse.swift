//
//  JMVerse.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/13/22.


import SwiftUI

struct JMVerse {
    //private(set) var verseArray: Array<Word>

    //private var indexOfTheWord: Int?

    struct Word: Identifiable {
        let id = UUID()
        let word: String
    }

    //init(verseReference: Reference)
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

struct blank {
    var text: String
    let order: Int
}
