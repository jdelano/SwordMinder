//
//  Verse.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation

/// Represents a **single** verse in the Bible
struct Verse: Decodable {
    
    /// The reference of the verse
    var reference: Reference
    
    /// The text of the verse
    var text: String
    
    /// Initializer used to import verses from a file
    ///
    /// - Parameter decoder: decoder used to import the verse
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.reference = try decoder.singleValueContainer().decode(Reference.self)
    }
    
    /// CodingKeys for this struct used to decode the verse text; the reference is decoded separately
    enum CodingKeys: String, CodingKey {
        case text
    }
    
    /// Produces a string representation of the verse
    ///
    /// - Returns: A string representation of the verse text, preceded by a superscripted verse number
    func toString() -> String {
        "\(reference.verse.superscriptString)\(text)"
    }
}
