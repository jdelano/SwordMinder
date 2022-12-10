//
//  LetterTile.swift
//  SwordMinder
//
//  Created by user226647 on 12/10/22.
//

import Foundation

struct LetterTile {
    var letter: Character
    var isShown: Bool = false
    
    init(letter: Character) {
        self.letter = letter
        self.isShown = false
    }
}
