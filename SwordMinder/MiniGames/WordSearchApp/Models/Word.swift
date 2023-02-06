//
//  Word.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import Foundation

struct Word : Decodable, Identifiable, Comparable, Hashable {
    static func < (lhs: Word, rhs: Word) -> Bool {
        lhs.text < rhs.text
    }
    
    var text: String
    var found: Bool = false
    var id = UUID()
}
