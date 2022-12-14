//
//  JMReference.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/14/22.
//

import SwiftUI

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
