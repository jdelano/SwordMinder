//
//  Verse.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation

/// Represents a **single** verse in the Bible
struct Verse {
    
    /// The reference of the verse
    var reference: Reference
    
    /// Whether or not the verse text has been retrieved from the Internet yet
    var hasLoadedText: Bool {
        _text != ""
    }
    
    var version: Translation
    
    /// The locally cached copy of the verse text
    private var _text: String = ""
    
    /// The text of the verse
    /// When the property is accessed the first time, it goes out to jsonbible.com and retrieves the verse text, and stores it in the `_text` backing property.
    var text: String {
        mutating get async throws {
            if _text == "" {
                if var searchURLComponents = URLComponents(string:"https://jsonbible.com/search/verses.php") {
                    searchURLComponents.queryItems = [URLQueryItem(name: "json", value: self.json())]
                    if let searchURL = searchURLComponents.url {
                        let (verseData, _) = try await URLSession.shared.data(from: searchURL)
                        let verseJSON = try JSONDecoder().decode(VerseResponse.self, from: verseData)
                        _text = verseJSON.text
                    }
                }
            }
            return _text
        }
    }
    
    /// Produces a string array of the words within the verse text
    var words: [String] {
         mutating get async throws {
             try await text.alphaOnly().components(separatedBy: " ")
         }
    }
    
    func json() -> String? {
        if let encodedReference = try? JSONEncoder().encode(VerseRequest(for: self)) {
            return String(data: encodedReference, encoding: .utf8)
        }
        return nil
    }

    
    /// Verse initializer - use to represent a single Bible verse
    /// - Parameter reference: The reference of the verse to create
    init(reference: Reference, version: Translation = .esv) {
        self.reference = reference
        self.version = version
    }

    /// Produces a string representation of the verse
    ///
    /// - Returns: A string representation of the verse text, preceded by a superscripted verse number
    mutating func toString() async throws -> String {
        "\(reference.verse.superscriptString)\(try await text)"
    }
}
