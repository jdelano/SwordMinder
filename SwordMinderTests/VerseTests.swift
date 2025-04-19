//
//  VerseTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/2/22.
//

import XCTest
@testable import SwordMinder

// MARK: - MockVerseProvider

actor MockVerseProvider: VerseProvider {
    func getText(for request: VerseRequest) async throws -> String {
        switch (request.book, request.chapter, request.verse, request.version) {
            case (.genesis, 1, 1, _):
                return "In the beginning, God created the heavens and the earth."
            case (.john, 3, 16, .kjv):
                return "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life."
            case (.john, 3, 16, .niv):
                return "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life."
            case (.john, 3, 16, .nasb):
                return "For God so loved the world, that He gave His only begotten Son, that whoever believes in Him shall not perish, but have eternal life."
            default:
                throw NSError(domain: "MockVerseProvider", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock verse not found"])
        }
    }
}

// MARK: - Tests

final class VerseTests: XCTestCase {
    
    override func setUp() async throws {
        Verse.provider = MockVerseProvider()
    }
    
    // MARK: - Genesis 1:1 Tests
    
    func testVerseTextGen11() async throws {
        let v = Verse(reference: Reference())
        let text = try await v.text()
        XCTAssertEqual(text, "In the beginning, God created the heavens and the earth.")
    }
    
    func testVerseToStringGen11() async throws {
        let v = Verse(reference: Reference())
        let text = try await v.formattedText()
        XCTAssertEqual(text, "¹In the beginning, God created the heavens and the earth.")
    }
    
    func testVerseWordsGen11() async throws {
        let v = Verse(reference: Reference(book: .genesis, chapter: 1, verse: 1), translation: .esv)
        let words = try await v.words()
        XCTAssertEqual(words.count, 10)
        XCTAssertEqual(words[0], "In")
        XCTAssertEqual(words[2], "beginning")
        XCTAssertEqual(words[6], "heavens")
        XCTAssertEqual(words[9], "earth")
    }
    
    // MARK: - John 3:16 in Various Translations
    
    func testVerseTextJn316NASB() async throws {
        let v = Verse(reference: Reference(book: .john, chapter: 3, verse: 16), translation: .nasb)
        let text = try await v.text()
        XCTAssertEqual(text, "For God so loved the world, that He gave His only begotten Son, that whoever believes in Him shall not perish, but have eternal life.")
    }
    
    func testVerseTextJn316NIV() async throws {
        let v = Verse(reference: Reference(book: .john, chapter: 3, verse: 16), translation: .niv)
        let text = try await v.text()
        XCTAssertEqual(text, "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.")
    }
    
    func testVerseTextJn316KJV() async throws {
        let v = Verse(reference: Reference(book: .john, chapter: 3, verse: 16), translation: .kjv)
        let text = try await v.text()
        XCTAssertEqual(text, "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.")
    }
}
