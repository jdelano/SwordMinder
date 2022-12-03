//
//  Book.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation


/// Used  to represent a book of the Bible.
struct Book: Codable, Equatable, Identifiable, Comparable {
    var id: UUID = UUID()
    var abbr: String
    var name: String
    var chapters: [ChapterVerse] = []
    
    static let abbreviations = ["Genesis" : "Gen", "Exodus" : "Exod", "Leviticus" : "Lev", "Numbers" : "Num", "Deuteronomy" : "Deut", "Joshua" : "Josh", "Judges" : "Judg", "Ruth" : "Ruth", "1 Samuel" : "1Sam", "2 Samuel" : "2Sam", "1 Kings" : "1Kgs", "2 Kings" : "2Kgs", "1 Chronicles" : "1Chr", "2 Chronicles" : "2Chr", "Ezra" : "Ezra", "Nehemiah" : "Neh", "Esther" : "Esth", "Job" : "Job", "Psalms" : "Ps", "Proverbs" : "Prov", "Ecclesiastes" : "Eccl", "Song of Solomon" : "Song", "Isaiah" : "Isa", "Jeremiah" : "Jer", "Lamentations" : "Lam", "Ezekiel" : "Ezek", "Daniel" : "Dan", "Hosea" : "Hos", "Joel" : "Joel", "Amos" : "Amos", "Obadiah" : "Obad", "Jonah" : "Jonah", "Micah" : "Mic", "Nahum" : "Nah", "Habakkuk" : "Hab", "Zephaniah" : "Zeph", "Haggai" : "Hag", "Zechariah" : "Zech", "Malachi" : "Mal", "Matthew" : "Matt", "Mark" : "Mark", "Luke" : "Luke", "John" : "John", "Acts" : "Acts", "Romans" : "Rom", "1 Corinthians" : "1Cor", "2 Corinthians" : "2Cor", "Galatians" : "Gal", "Ephesians" : "Eph", "Philippians" : "Phil", "Colossians" : "Col", "1 Thessalonians" : "1Thess", "2 Thessalonians" : "2Thess", "1 Timothy" : "1Tim", "2 Timothy" : "2Tim", "Titus" : "Titus", "Philemon" : "Phlm", "Hebrew" : "Heb", "James" : "Jas", "1 Peter" : "1Pet", "2 Peter" : "2Pet", "1 John" : "1John", "2 John" : "2John", "3 John" : "3John", "Jude" : "Jude", "Revelation" : "Rev"]
    
    static let names = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrew", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    
    private enum CodingKeys: String, CodingKey {
        case abbr
        case name = "book"
        case chapters
    }
    
    init?(named name: String) {
        if let abbr = Book.abbreviations[name] {
            self.abbr = abbr
            self.name = name
            self.chapters = []
        } else {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.abbr = try container.decodeIfPresent(String.self, forKey: .abbr) ?? ""
        self.name = try container.decode(String.self, forKey: .name)
        self.chapters = try container.decodeIfPresent([ChapterVerse].self, forKey: .chapters) ?? []
        self.id = UUID()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(abbr, forKey: .abbr)
        try container.encode(name, forKey: .name)
        try container.encode(chapters, forKey: .chapters)
    }

    
    static func ==(lhs: Book, rhs: Book) -> Bool {
        lhs.name == rhs.name
    }
    
    
    static func < (lhs: Book, rhs: Book) -> Bool {
        if let lhsIndex = names.firstIndex(where: { $0 == lhs.name }),
           let rhsIndex = names.firstIndex(where: { $0 == rhs.name }) {
            return lhsIndex < rhsIndex
        }
        return false
    }
    
    
    static func > (lhs: Book, rhs: Book) -> Bool {
        if let lhsIndex = names.firstIndex(where: { $0 == lhs.name }),
           let rhsIndex = names.firstIndex(where: { $0 == rhs.name }) {
            return lhsIndex > rhsIndex
        }
        return false
    }
    
    
    struct ChapterVerse: Codable {
        var chapter : Int
        var verses : Int
    }
    
}
