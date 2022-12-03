//
//  Reference.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation

/// Represents a Bible reference containing book, chapter, and verse for a **single** verse
struct Reference: Codable, Equatable, Comparable {
    /// The Bible book name represented in the reference. The book name should be the full name of the Bible book in string format.
    var book: Book
    
    /// The chapter number represented in the reference
    var chapter: Int
    
    /// The verse number represented in the reference
    var verse: Int
    
    /// Initializes a new `Reference` based on the book, chapter, and verse number of the reference
    ///
    /// - Parameters:
    ///   - book: Should contain the full name of the book (no abbreviations are supported)
    ///   - chapter: Should contain the chapter number of the reference
    ///   - verse: Should contain the verse number of the reference
    init(book: Book = Book(named: "Genesis")!, chapter: Int = 1, verse: Int = 1) {
        self.book = book
        self.chapter = chapter
        self.verse = verse
    }
    
    enum CodingKeys: CodingKey {
        case book
        case chapter
        case verse
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.book = try decoder.singleValueContainer().decode(Book.self)
        self.chapter = try container.decode(Int.self, forKey: .chapter)
        self.verse = try container.decode(Int.self, forKey: .verse)
    }
    
    func encode(to encoder: Encoder) throws {
        var bookContainer = encoder.singleValueContainer()
        try bookContainer.encode(book)
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chapter, forKey: .chapter)
        try container.encode(verse, forKey: .verse)
    }
    
    /// Produces a String representation of the Reference
    ///
    /// - Returns: A String representation of the verse's reference (e.g., "John 3:16")
    func toString() -> String {
        "\(book.name) \(chapter):\(verse)"
    }
    
    static func < (lhs: Reference, rhs: Reference) -> Bool {
        (lhs.book < rhs.book) ||
        (lhs.book == rhs.book && lhs.chapter < rhs.chapter) ||
        (lhs.book == rhs.book && lhs.chapter == rhs.chapter && lhs.verse < rhs.verse)
    }
}
