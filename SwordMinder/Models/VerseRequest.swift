//
//  VerseRequest.swift
//  SwordMinder
//
//  Created by John Delano on 1/27/23.
//

import Foundation

struct VerseRequest: Encodable {
    let book: Book
    let chapter: Int
    let verse: Int
    let version: Translation
    
    init(for verse: Verse) {
        self.book = verse.reference.book
        self.chapter = verse.reference.chapter
        self.verse = verse.reference.verse
        self.version = verse.version
    }
}
