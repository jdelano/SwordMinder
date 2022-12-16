//
//  WordSortingModel.swift
//  SwordMinder
//
//  Created by Caleb Kowalewski on 12/13/22.
//

import Foundation

//private (set) var score: Int = 100
// user would start off with a score of a 100
//Once I get the word dropping box working correctly i would compare to see if the
// two words are the same in the tapped box and the free falling box
// if they are the same, then the score would add 10pts
// if the words are diffrent / the wrong place then subtract 10 pts.
// ultimatly if the user achieves over 200 pts they will recieve a gem

//need to create each of the words in the boxes at the bottom with a unique id
struct VerseDrop {
    
  var verse: [Word]
  var filledWords: Set<UUID>

  mutating func fillWord(_ word: Word) {
    filledWords.insert(word.id)
      
  }

  struct Word: Identifiable {
    var id = UUID()
    var text: String
    var position: Int
  }
}
