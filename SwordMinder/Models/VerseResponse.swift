//
//  VerseJSON.swift
//  SwordMinder
//
//  Created by John Delano on 1/26/23.
//

import Foundation

/// Represents the response returned from the Bible verse API after a successful verse lookup.
///
/// This struct is used to decode the JSON payload returned by the API, containing the metadata and text
/// of the requested verse. It includes the book name, chapter number, verse number (or count), the verse text,
/// and the translation version used.
///
/// - Important: This type conforms to `Decodable` and must match the structure of the JSON returned by the remote API.
///
/// - SeeAlso: `VerseRequest`, `VerseCache`
struct VerseResponse: Decodable {
    
    /// The name of the book (e.g., "John")
    let book: String
    
    /// The chapter number within the book
    let chapter: Int
    
    /// The verse number or count (depends on API; may be 1 even for multi-verse results)
    let verses: Int
    
    /// The actual verse text retrieved from the API
    let text: String
    
    /// The Bible version used (e.g., "ESV", "KJV")
    let version: String
}
