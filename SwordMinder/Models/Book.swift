//
//  Book.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation


/// Used  to represent a book of the Bible.
enum Book: String, Codable, Equatable, Identifiable, Comparable, CaseIterable {
    // Old Testament
    case genesis = "Genesis", exodus = "Exodus", leviticus = "Leviticus", numbers = "Numbers", deuteronomy = "Deuteronomy"
    case joshua = "Joshua", judges = "Judges", ruth = "Ruth"
    case firstSamuel = "1 Samuel", secondSamuel = "2 Samuel"
    case firstKings = "1 Kings", secondKings = "2 Kings"
    case firstChronicles = "1 Chronicles", secondChronicles = "2 Chronicles"
    case ezra = "Ezra", nehemiah = "Nehemiah", esther = "Esther"
    case job = "Job", psalms = "Psalms", proverbs = "Proverbs", ecclesiastes = "Ecclesiastes", songOfSolomon = "Song of Solomon"
    case isaiah = "Isaiah", jeremiah = "Jeremiah", lamentations = "Lamentations", ezekiel = "Ezekiel", daniel = "Daniel"
    case hosea = "Hosea", joel = "Joel", amos = "Amos", obadiah = "Obadiah", jonah = "Jonah", micah = "Micah", nahum = "Nahum"
    case habakkuk = "Habakkuk", zephaniah = "Zephaniah", haggai = "Haggai", zechariah = "Zechariah", malachi = "Malachi"
    
    // New Testament
    case matthew = "Matthew", mark = "Mark", luke = "Luke", john = "John", acts = "Acts", romans = "Romans"
    case firstCorinthians = "1 Corinthians", secondCorinthians = "2 Corinthians"
    case galatians = "Galatians", ephesians = "Ephesians", philippians = "Philippians", colossians = "Colossians"
    case firstThessalonians = "1 Thessalonians", secondThessalonians = "2 Thessalonians"
    case firstTimothy = "1 Timothy", secondTimothy = "2 Timothy", titus = "Titus", philemon = "Philemon", hebrews = "Hebrews"
    case james = "James", firstPeter = "1 Peter", secondPeter = "2 Peter"
    case firstJohn = "1 John", secondJohn = "2 John", thirdJohn = "3 John", jude = "Jude", revelation = "Revelation"
    
    var id: Self { self }
    
    /// Retrieves the next Book of the Bible after this one; Returns nil if the current Book is Revelation
    var next: Book? {
        guard let currentIndex = Book.allCases.firstIndex(of: self),
              currentIndex < Book.allCases.count - 1 else { return nil }
        return Book.allCases[currentIndex + 1]
    }
    
    // MARK: - Comparable
    
    /// Determines if one book occurs before the other book in the Bible
    /// - Parameters:
    ///   - lhs: Left hand side
    ///   - rhs: Right hand side
    /// - Returns: true if the left hand side book occurs before the right hand side book; otherwise, returns false
    static func <(lhs: Book, rhs: Book) -> Bool {
        guard let lhsIndex = Book.allCases.firstIndex(of: lhs),
              let rhsIndex = Book.allCases.firstIndex(of: rhs) else { return false }
        return lhsIndex < rhsIndex
    }
}
