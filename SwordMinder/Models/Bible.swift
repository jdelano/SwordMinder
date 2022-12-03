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
    
    /// Dictionary containing various abbreviations of Bible book names and the associated full name of the Bible book
    /// Used in the "matching" functions to locate books based on a pattern.
    private var abbreviations: Dictionary<String, String> = [:]
    
    /// Array of `Book` structs that contain all the books of the Bible along with all the chapters and number of verses in each book
    private var books: [Book] = []
    
    /// Array of Verse structs that contain the all the references and text of all the verses in the Bible
    private var verses: [Verse] = []
    
    var isLoaded: Bool = false
    
    /// Initialize a new instance of the Bible struct
    ///
    /// - Parameters:
    ///   - translation: One of the supported translations of the Bible (KJV is currently the only one supported)
    init(translation: Translation = .kjv) {
        self.translation = translation
    }
    
    /// Asynchronously initializes the Bible contents.
    /// Repeatedly calling this function on the same instance has no affect
    /// To force a reload of Bible contents, set isLoaded = false before calling
    @MainActor
    mutating func loadBible() async {
        if !isLoaded {
            self.abbreviations = await URL.decode("abbreviations")!
            self.books = await URL.decode("books")!
            switch translation {
                case .kjv:
                    self.verses = await URL.decode("kjv")!
            }
        }
        isLoaded = true
    }
    
    
    /// Retrieves an array of Book items
    ///
    /// - Parameter pattern: A string pattern that can be used to match a Bible book name
    /// - Returns: Array of Books that have a name matching the pattern provided
    func books(matching pattern: String) -> [Book] {
        books.filter({ abbreviations.filter({ $0.key.lowercased().contains(pattern.lowercased()) }).values.contains($0.name) })
    }
    
    /// Retrieves the first book that matches the pattern provided
    /// - Parameter pattern: A string pattern that can be used to match a Bible book name
    /// - Returns: An optional `Book` that is the first book that matches the pattern provided
    func book(matching pattern: String) -> Book? {
        books(matching: pattern).first
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
            return Reference(book: book, chapter: chapter, verse: verse)
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
        if let beginReference = reference(fromString: begin) {
            if let end,
               let endReference = reference(fromString: end) {
                return Passage(from: beginReference, to: endReference)
            }
            return Passage(from: beginReference)
        }
        return nil
    }
    
    
    /// Retrieves a `String` containing the text of the specified `Passage`
    ///
    /// - Parameter passage: The `Passage` for which the verse text is being retrieved
    /// - Returns: The verse text of the requested passage
    func text(for reference: Reference) -> String {
        var text = ""
        if let index = self.verses.firstIndex(where: { $0.reference == reference }) {
            text = self.verses[index].toString()
        }
        return text
    }

    
    /// Retrieves a `String` containing the text of the specified `Passage`
    ///
    /// - Parameter passage: The `Passage` for which the verse text is being retrieved
    /// - Returns: The verse text of the requested passage
    func text(for passage: Passage) -> String {
        var passageVerses = [Verse]()
        if let beginIndex = self.verses.firstIndex(where: { $0.reference == passage.startReference }) {
            passageVerses = [verses[beginIndex]]
            if let endIndex = self.verses.firstIndex(where: { $0.reference == passage.endReference }) {
                if beginIndex <= endIndex {
                    passageVerses = Array(verses[beginIndex...endIndex])
                }
            }
        }
        var text = ""
        // Prepend second and following verses with a space
        passageVerses.indices.forEach { text += "\($0 > 0 ? " " : "")\(passageVerses[$0].toString())" }
        return text
    }
    
    

    
    /// Translation enumeration containing the different possible translations that this API intends to support over time
    /// Currently, the KJV translation is the only one supported.
    enum Translation {
        case kjv
    }
}
