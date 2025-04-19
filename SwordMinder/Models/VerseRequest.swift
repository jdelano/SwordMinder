//
//  VerseRequest.swift
//  SwordMinder
//
//  Created by John Delano on 1/27/23.
//

import Foundation

/// Represents the data required to request a specific verse from the Bible API.
///
/// This struct encodes the necessary information—book, chapter, verse, and translation version—
/// into a format that can be serialized to JSON for use in an API request to services such as `jsonbible.com`.
/// It is typically constructed from a `Reference` and a `Translation`.
///
/// - Important: This type conforms to `Encodable` so it can be passed as a JSON payload in the query string
///   or request body, depending on the API.
///
/// - SeeAlso: `Reference`, `Translation`, `VerseCache`
struct VerseRequest: Encodable, Hashable {
    
    /// The book of the Bible (e.g., Genesis, John)
    let book: Book
    
    /// The chapter within the book
    let chapter: Int
    
    /// The verse within the chapter
    let verse: Int
    
    /// The translation version (e.g., ESV, KJV)
    let version: Translation
    
    /// Initializes a `VerseRequest` from a `Reference` and `Translation`.
    ///
    /// - Parameters:
    ///   - reference: The reference identifying the verse location (book, chapter, verse).
    ///   - translation: The Bible translation version to retrieve.
    init(reference: Reference, translation: Translation) {
        self.book = reference.book
        self.chapter = reference.chapter
        self.verse = reference.verse
        self.version = translation
    }
}
