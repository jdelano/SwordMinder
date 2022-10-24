//
//  Bible.swift
//  SwordMinder
//
//  Created by John Delano on 10/8/2022.
//

import Foundation


/// The Bible struct is the Model representing a single translation of the Holy Scriptures
struct Bible {
    /// Determines which translation of the Bible this struct represents; only translation currently supported is KJV
    private(set) var translation: Translation
    
    /// Array of Verse structs that contain the all the references and text of all the verses in the Bible
    private var verses: [Verse] = []

    /// Retrieves the URL for the KJV translation of the Bible
    private static var kjvURL: URL {
        Bundle.main.url(forResource: "kjv", withExtension: "json")!
    }

    /// Used internally to store the number of chapters in each book and the number of verses in each chapter
    private static var books: [BibleBook] {
        if let fileLocation = Bundle.main.url(forResource: "references", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileLocation)
                return try JSONDecoder().decode([BibleBook].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
    
    
    
    /// Initialize a new instance of the Bible struct
    /// - Parameters:
    ///   - translation: One of the supported translations of the Bible (KJV is currently the only one supported)
    ///   - url: URL pointing to the location of the JSON file that contains the text of the specified translation
    init(translation: Translation) {
        self.translation = translation
        switch translation {
            case .kjv:
                do {
                    let data = try Data(contentsOf: Bible.kjvURL)
                    self.verses = try JSONDecoder().decode([Verse].self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            default: break
        }
    }
    
    /// Used internally to find the index in the verses array of the specified reference
    /// - Parameter reference: Reference of the verse to locate
    /// - Returns: The index position of the specified reference in the verses array if found; otherwise returns nil
    private func indexOfVerse(forReference reference: Reference) -> Int? {
        verses.firstIndex { $0.reference == reference }
    }
    
    
    /// Retrieves a `Passage` containing all the verses starting from the beginning reference up to and including the ending reference.
    ///
    /// - Parameters:
    ///   - begin: Starting reference to include in the Passage
    ///   - end: Ending reference to include in the Passage. If nil, then the Passage will only contain the verse at the starting reference.
    /// - Returns: A Passage containing all the verses identified by the range of references specified. Returns nil if references cannot be found or are invalid.
    func passage(from begin: Reference, to end: Reference? = nil) -> Passage? {
        if let beginIndex = indexOfVerse(forReference: begin) {
            if let end = end, let endIndex = indexOfVerse(forReference: end) {
                return Passage(verses: Array(verses[beginIndex...endIndex]))
            } else {
                return Passage(verses: [verses[beginIndex]])
            }
        } else {
            return nil
        }
    }
    
    
    /// Gets the number of chapters in the specified book of the Bible
    /// - Parameter book: The full Bible book name in String format
    /// - Returns: The total number of chapters in the specified book; returns nil if book is invalid or not found.
    static func chapters(in book: String) -> Int? {
        books.first(where: { $0.book == book })?.chapters.count
    }
    
    /// Gets the number of verses in the specified book and chapter of the Bible
    /// - Parameters:
    ///   - book: The full Bible book name in String format
    ///   - chapter: The chapter number in the book
    /// - Returns: The total number of verses in the specified book and chapter; returns nil if the book is invalid or not found or if the number of chapters specified is invalid for the specified book.
    static func verses(in book: String, chapter: Int) -> Int? {
        books.first(where: { $0.book == book })?.chapters[chapter - 1].verses
    }
    
    /// Translation enumeration containing the different possible translations that this API intends to support over time
    /// Currently, the KJV translation is the only one supported.
    enum Translation {
        case kjv
        case esv
        case niv
        case csb
    }
    
    /// Represents a Bible reference containing book, chapter, and verse for a **single** verse
    struct Reference: Decodable, Equatable {
        /// The Bible book name represented in the reference. The book name should be the full name of the Bible book in string format.
        var book: String
        
        /// The chapter number represented in the reference
        var chapter: Int
        
        /// The verse number represented in the reference
        var verse: Int
        
        
        /// CodingKeys for importing references from JSON
        enum CodingKeys: CodingKey {
            case book
            case chapter
            case verse
        }
        
        /// Decoding init for importing references from JSON
        /// - Parameter decoder: decoder used to import file
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Bible.Reference.CodingKeys.self)
            self.book = try container.decode(String.self, forKey: Bible.Reference.CodingKeys.book)
            self.chapter = try container.decode(Int.self, forKey: Bible.Reference.CodingKeys.chapter)
            self.verse = try container.decode(Int.self, forKey: Bible.Reference.CodingKeys.verse)
        }
        
        /// Initializes a new `Reference` based on a String representation of a verse's reference
        /// - Parameter reference: should contain the full name of the Bible book (no abbreviations are supported) followed by a space,
        /// and then the chapter number, followed by a colon, and then the verse number.
        init(fromString reference: String) {
            let refSplit = reference.split(separator: " ")
            self.book = String(refSplit.first!)
            let chapVerse = refSplit.last!.split(separator: ":")
            self.chapter = Int(chapVerse[0])!
            self.verse = Int(chapVerse[1])!
        }
        
        /// Initializes a new `Reference` based on the book, chapter, and verse number of the reference
        /// - Parameters:
        ///   - book: Should contain the full name of the book (no abbreviations are supported)
        ///   - chapter: Should contain the chapter number of the reference
        ///   - verse: Should contain the verse number of the reference
        init(book: String, chapter: Int, verse: Int) {
            self.book = book
            self.chapter = chapter
            self.verse = verse
        }
        
        /// Produces a String representation of the Reference
        /// - Returns: A String representation of the verse's reference (e.g., "John 3:16")
        func toString() -> String {
            "\(book) \(chapter):\(verse)"
        }
    }
    
    
    /// Represents a **single** verse in the Bible
    struct Verse: Decodable {
        
        /// The reference of the verse
        var reference: Reference
        
        /// The text of the verse
        var text: String
         
        
        /// Initializer used to import verses from a file
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
        /// - Returns: A string representation of the verse text, preceded by a superscripted verse number
        func toString() -> String {
            "\(reference.verse.superscriptString)\(text)"
        }
    }
    
    /// Represents a passage of scripture, containing one or more verses. Passages should not extend across book boundaries.
    struct Passage: Identifiable {
        /// id used by Identifiable
        let id = UUID()
        
        /// Contains the Verse objects that are part of this passage.
        private let verses: [Verse]
        
        /// Provides a nicely formatted reference representing the passage, (e.g., John 3:16-17 or Romans 5:12-6:2)
        var reference: String {
            if let beginReference = verses.first?.reference,
               let endReference = verses.last?.reference {
                var referenceString = beginReference.toString()
                if endReference.chapter > beginReference.chapter {
                    referenceString += "-\(endReference.chapter):\(endReference.verse)"
                } else if endReference.verse > beginReference.verse {
                    referenceString += "-\(endReference.verse)"
                }
                return referenceString
            } else {
                return ""
            }
        }
        
        /// Retrieve the passage of scripture corresponding to the range of verses specified.
        var text: String {
            var passage = ""
            // Prepend second and following verses with a space
            verses.indices.forEach { passage += "\($0 > 0 ? " " : "")\(verses[$0].toString())" }
            return passage
        }
        
        /// Initializes a new Passage struct.
        ///
        /// - Note: Use the `Bible.passage` function to create a Passage.
        ///
        /// - Parameter verses: array of verses to include in the passage.
        fileprivate init(verses: [Verse]) {
            self.verses = verses
        }
    }
    
    
    /// Used internally to represent the total number verses in each chapter.
    private struct ChapterVerses: Codable, Hashable {
        var chapter: Int
        var verses: Int
    }

    /// Used internally to represent the total number of chapters and verses within each book of the Bible.
    private struct BibleBook: Codable, Hashable, Equatable {
        var abbr: String
        var book: String
        var chapters: [ChapterVerses]
        
        static func == (lhs: BibleBook, rhs: BibleBook) -> Bool {
            lhs.book == rhs.book
        }
    }
}
