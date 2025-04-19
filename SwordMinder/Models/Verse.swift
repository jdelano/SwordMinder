//
//  Verse.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation

/// Represents a **single** verse in the Bible
struct Verse: Equatable, Codable, Identifiable, Hashable {
    static var provider: VerseProvider = VerseCache.shared
    
    var id: String { "\(reference.book.rawValue)-\(reference.chapter)-\(reference.verse)-\(translation)"}
    /// The reference of the verse
    var reference: Reference
    var translation: Translation
    
    /// Verse initializer - use to represent a single Bible verse
    /// - Parameter reference: The reference of the verse to create
    init(reference: Reference, translation: Translation = .esv) {
        self.reference = reference
        self.translation = translation
    }
    
    /// The text of the verse
    /// When the property is accessed the first time, it goes out to jsonbible.com and retrieves the verse text, and stores it in the `_text` backing property.
    func text() async throws -> String {
        try await Self.provider.getText(for: VerseRequest(reference: reference, translation: translation))
    }
    
    /// Produces a string representation of the verse
    ///
    /// - Returns: A string representation of the verse text, preceded by a superscripted verse number
    func formattedText() async throws -> String {
        "\(reference.verse.superscriptString)\(try await text())"
    }

    /// Produces a string array of the words within the verse text
    func words() async throws -> [String] {
        try await text().alphaOnly().components(separatedBy: " ")
    }
}
