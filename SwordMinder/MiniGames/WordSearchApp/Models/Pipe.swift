//
//  Pipe.swift
//  SwordMinder
//
//  Created by John Delano on 2/6/23.
//

import Foundation

struct Pipe: Identifiable {
    let id = UUID()
    let startRow: Int
    let startCol: Int
    let endRow: Int
    let endCol: Int
    var found: Bool = false
}
