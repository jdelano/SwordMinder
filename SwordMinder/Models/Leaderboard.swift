//
//  Leaderboard.swift
//  SwordMinder
//
//  Created by John Delano on 10/9/22.
//

import Foundation

struct Leaderboard : Codable {
    private(set) var entries: [Entry] = []
    
    mutating func add(app: String, score: Int) {
        entries.append(Entry(app: app, score: score))
    }
    
    mutating func update(index: Int, score: Int) {
        entries[index].score = score
    }
    
    func json() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(Leaderboard.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try Leaderboard(json: data)
    }

    init(entries: [Entry] = []) {
        self.entries = entries
    }
    
    struct Entry: Identifiable, Codable {
        var id = UUID()
        var app: String = ""
        var score: Int = 0
    }
}
