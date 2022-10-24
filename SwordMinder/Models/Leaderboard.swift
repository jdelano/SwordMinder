//
//  Leaderboard.swift
//  SwordMinder
//
//  Created by John Delano on 10/9/22.
//

import Foundation

struct Leaderboard {
    private(set) var entries: [Entry] = []
    
    mutating func add(app: String, score: Int) {
        entries.append(Entry(app: app, score: score))
    }
    
    mutating func update(index: Int, score: Int) {
        entries[index].score = score
    }
    
    struct Entry: Identifiable {
        var id = UUID()
        var app: String = ""
        var score: Int = 0
    }
}
