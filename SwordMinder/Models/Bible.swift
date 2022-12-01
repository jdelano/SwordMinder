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
    private var abbreviations: Dictionary<String, String> = [:]
    private var books: [Book] = []
    
    /// Array of Verse structs that contain the all the references and text of all the verses in the Bible
    private var verses: [Verse] = []
    
    var isLoaded: Bool = false
    
    /// Initialize a new instance of the Bible struct
    ///
    /// - Parameters:
    ///   - translation: One of the supported translations of the Bible (KJV is currently the only one supported)
    init(translation: Translation) {
        self.translation = translation
    }
    
    /// Asynchronously initializes the bible contents.
    /// Repeatedly calling this function on the same instance has no affect
    /// To force a reload of Bible contents, set isLoaded = false before calling
    @MainActor
    mutating func initBible() async {
        if !isLoaded {
            self.abbreviations = await URL.decode("abbreviations")!
            self.books = await URL.decode("books")!
            switch translation {
                case .kjv:
                    self.verses = await URL.decode("kjv")!
                default: break
            }
        }
        isLoaded = true
    }
    
    
    var bookNames: [String] {
        books.map( { $0.name })
    }
    
    /// Retrieves an array of Book items
    ///
    /// - Parameter pattern: A string pattern that can be used to match a Bible book name
    /// - Returns: Array of Books that have a name matching the pattern provided
    func books(matching pattern: String) -> [Book] {
        books.filter({ abbreviations.filter({ $0.key.lowercased().contains(pattern.lowercased()) }).values.contains($0.name) })
    }
    
    /// Gets the number of chapters in the specified book of the Bible
    ///
    /// - Parameter book: The `Book` struct you are looking up
    /// - Returns: The total number of chapters in the specified book; returns nil if the book is invalid or not found.
    func chapters(in book: Book) -> [Int] {
        var chapterArray = [Int]()
        if let chapters = books.first(where: { $0 == book })?.chapters {
            for ch in 1...chapters.count { chapterArray.append(ch) }
        }
        return chapterArray
    }
    
    /// Gets the number of chapters in the specified book of the Bible
    ///
    /// - Parameter book: The `Book` struct you are looking up
    /// - Returns: The total number of chapters in the specified book; returns nil if the book is invalid or not found.
    func chapters(matching book: String) -> [Int] {
        let matchingBooks = books(matching: book)
        if !matchingBooks.isEmpty {
            return chapters(in: matchingBooks.first!)
        }
        return []
    }
    
    
    /// Gets the number of verses in the specified book and chapter of the Bible
    /// - Parameters:
    ///   - book: The `Book` struct you are looking up
    ///   - chapter: The chapter number in the book
    /// - Returns: The total number of verses in the specified book and chapter; returns nil if the book is invalid or not found or if the number of chapters specified is invalid for the specified book.
    func verses(in book: Book, chapter: Int) -> [Int] {
        var versesArray = [Int]()
        if chapter <= chapters(in: book).count,
           let verses = books.first(where: { $0 == book })?.chapters[chapter - 1].verses {
            for vs in 1...verses { versesArray.append(vs) }
        }
        return versesArray
    }
    
    
    /// Gets the number of verses in the specified book and chapter of the Bible
    /// - Parameters:
    ///   - book: The name of the book in String format you are looking up
    ///   - chapter: The chapter number in the book
    /// - Returns: The total number of verses in the specified book and chapter; returns nil if the book is invalid or not found or if the number of chapters specified is invalid for the specified book.
    func verses(matching book: String, chapter: Int) -> [Int] {
        let matchingBooks = books(matching: book)
        if !matchingBooks.isEmpty {
            return verses(in: matchingBooks.first!, chapter: chapter)
        }
        return []
    }
    
    
    /// Creates a new reference for Genesis 1:1
    ///
    /// - Returns: A reference to Genesis 1:1
    static func reference() -> Reference {
        Reference(book: Book(name: "Genesis"), chapter: 1, verse: 1)
    }
    
    /// Initializes a new `Reference` based on a String representation of a verse's reference
    ///
    /// Only supports a reference to a single verse in the Bible (i.e., ranges are not supported and will return nil)
    ///
    /// - Parameter reference: should contain the name or abbreviation of the Bible book followed by a space,
    /// and then the chapter number, followed by a colon, and then the verse number.
    func reference(fromString reference: String) -> Reference? {
        let pattern = /\b(?:(?<seq>I+|1st|2nd|3rd|First|Second|Third|[123]) )?(?<bk>\w+)\b(?:[ .)\n|](?<ch>\d+)(?::(?<vs>\d+)){0,2}\b)?/
        if let result = try? pattern.wholeMatch(in: reference), let chap = result.ch, let ch = Int(chap), let vrs = result.vs, let vs = Int(vrs) {
            let bk = String((result.seq == nil ? "" : result.seq! + " ") + result.bk)
            let books = books(matching: bk)
            if books.count >= 1 {
                return (Reference(book: books.first!, chapter: ch, verse: vs))
            }
        }
        return nil
    }
    
    
    /// Initializes a new `Reference` based on a `Book`, chapter, and verse
    ///
    /// - Parameters:
    ///   - book: The `Book` of the Bible
    ///   - chapter: The chapter number of the reference
    ///   - verse: The verse number of the reference
    /// - Returns: A reference corresponding to the provided book, chapter, and verse
    func reference(book: Book, chapter: Int, verse: Int) -> Reference {
        Reference(book: book, chapter: chapter, verse: verse)
    }
    
    
    /// Initializes a new `Reference` based on a String representation of the book, a chapter, and verse number
    ///
    /// Only supports a reference to a single verse in the Bible (i.e., ranges are not supported and will return nil)
    ///
    /// - Parameters:
    ///   -  book: The name or abbreviation of the book; If the abbreviation matches multiple book names, the first matching book is used
    ///   - chapter: The chapter number of the reference
    ///   - verse: The verse number of the reference
    /// - Returns: A reference corresponding to the provided book name, chapter, and verse
    /// and then the chapter number, followed by a colon, and then the verse number.
    func reference(matching book: String, chapter: Int, verse: Int) -> Reference? {
        if let book = books(matching: book).first {
            return reference(book: book, chapter: chapter, verse: verse)
        }
        return nil
    }
    
    
    /// Retrieves a `Passage` containing all the verses starting from the beginning reference up to and including the ending reference.
    ///
    /// - Parameters:
    ///   - begin: Starting reference to include in the Passage
    ///   - end: Ending reference to include in the Passage. If nil, then the Passage will only contain the verse at the starting reference.
    /// - Returns: A Passage containing all the verses identified by the range of references specified. Returns nil if references cannot be found or are invalid.
    func passage(from begin: Reference, to end: Reference? = nil) -> Passage? {
        if let beginIndex = verses.firstIndex(where: { $0.reference == begin }) {
            if let end, let endIndex = verses.firstIndex(where: { $0.reference == end }) {
                if beginIndex <= endIndex {
                    return Passage(verses: Array(verses[beginIndex...endIndex]))
                }
            }
            return Passage(verses: [verses[beginIndex]])
        }
        return nil
    }
    
    
    /// Retrieves a `Passage` containing all the verses starting from the beginning reference up to and including the ending reference.
    ///
    /// - Parameters:
    ///   - begin: Starting reference in string format to include in the Passage
    ///   - end: Ending reference in string format to include in the Passage. If nil, then the Passage will only contain the verse at the starting reference.
    /// - Returns: A Passage containing all the verses identified by the range of references specified. Returns nil if references cannot be found or are invalid.
    func passage(fromString begin: String, toString end: String? = nil) -> Passage? {
        if let beginReference = reference(fromString: begin),
           let beginIndex = verses.firstIndex(where: { $0.reference == beginReference }) {
            if let end,
               let endReference = reference(fromString: end),
               let endIndex = verses.firstIndex(where: { $0.reference == endReference }) {
                if beginIndex <= endIndex {
                    return Passage(verses: Array(verses[beginIndex...endIndex]))
                }
            }
            return Passage(verses: [verses[beginIndex]])
        }
        return nil
    }
    
    
    /// Translation enumeration containing the different possible translations that this API intends to support over time
    /// Currently, the KJV translation is the only one supported.
    enum Translation {
        case kjv
        case esv
        case niv
        case csb
    }
    
    // MARK: - Reference
    
    /// Represents a Bible reference containing book, chapter, and verse for a **single** verse
    struct Reference: Decodable, Equatable {
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
        fileprivate init(book: Book, chapter: Int, verse: Int) {
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
        
        
        /// Produces a String representation of the Reference
        ///
        /// - Returns: A String representation of the verse's reference (e.g., "John 3:16")
        func toString() -> String {
            "\(book.name) \(chapter):\(verse)"
        }
    }
    
    // MARK: - Verse
    
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
    
    // MARK: - Passage
    
    /// Represents a passage of scripture, containing one or more verses. Passages should not extend across book boundaries.
    struct Passage: Identifiable {
        /// id used by Identifiable
        let id = UUID()
        
        /// Contains the Verse objects that are part of this passage.
        private let verses: [Verse]
        
        /// Provides a nicely formatted reference representing the passage, (e.g., John 3:16-17 or Romans 5:12-6:2)
        var reference: String {
            var referenceString = ""
            if let beginReference = verses.first?.reference,
               let endReference = verses.last?.reference {
                referenceString = beginReference.toString()
                if endReference.chapter > beginReference.chapter {
                    referenceString += "-\(endReference.chapter):\(endReference.verse)"
                } else if endReference.verse > beginReference.verse {
                    referenceString += "-\(endReference.verse)"
                }
            }
            return referenceString
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
    
    // MARK: - Book
    
    /// Used  to represent a book of the Bible.
    struct Book: Decodable, Equatable, Identifiable {
        var id: UUID = UUID()
        var abbr: String
        var name: String
        var chapters: [ChapterVerse] = []
        
        static func ==(lhs: Book, rhs: Book) -> Bool {
            lhs.name == rhs.name
        }
        
        private enum CodingKeys: String, CodingKey {
            case abbr
            case name = "book"
            case chapters
        }
        
        init(abbr: String = "", name: String, chapters: [ChapterVerse] = []) {
            self.abbr = abbr
            self.name = name
            self.chapters = chapters
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            self.abbr = try container.decodeIfPresent(String.self, forKey: .abbr) ?? ""
            self.name = try container.decode(String.self, forKey: .name)
            self.chapters = try container.decodeIfPresent([ChapterVerse].self, forKey: .chapters) ?? []
            self.id = UUID()
        }
        
        
        struct ChapterVerse: Decodable {
            var chapter : Int
            var verses : Int
        }
        
    }
}
