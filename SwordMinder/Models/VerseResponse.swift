//
//  VerseJSON.swift
//  SwordMinder
//
//  Created by John Delano on 1/26/23.
//

import Foundation

struct VerseResponse: Decodable {
    let book: String
    let chapter: Int
    let verses: Int
    let text: String
    let version: String
}
