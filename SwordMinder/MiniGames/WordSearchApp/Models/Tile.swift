//
//  Tile.swift
//  SwordMinder
//
//  Created by John Delano on 12/5/22.
//

import Foundation

struct Tile : Identifiable, Hashable {
    var id = UUID()
    var letter : Character
    var selected : Bool = false
    var associatedWords = [String]()
}
