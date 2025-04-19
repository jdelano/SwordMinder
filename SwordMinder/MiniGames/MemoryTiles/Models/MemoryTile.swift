//
//  MemoryTile.swift
//  SwordMinder
//
//  Created by John Delano on 4/16/25.
//

import Foundation

struct MemoryTile: Identifiable, Hashable, Codable {
    var id = UUID()
    let text: String
}
