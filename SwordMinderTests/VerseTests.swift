//
//  VerseTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/2/22.
//

import XCTest
@testable import SwordMinder

final class VerseTests: XCTestCase {

    func testVerseTextGen11() async throws {
        var v = Verse(reference: Reference())
        let text = try await v.text
        XCTAssert(text == "In the beginning, God created the heavens and the earth.")
    }

    func testVerseToStringGen11() async throws {
        var v = Verse(reference: Reference())
        let text = try await v.toString()
        XCTAssert(text == "¹In the beginning, God created the heavens and the earth.")
    }
    
    func testVerseTextJn316NKJV() async throws {
        var v = Verse(reference: Reference(book: .john, chapter: 3, verse: 16), version: .nasb)
        let text = try await v.text
        XCTAssert(text == "For God so loved the world, that He gave His only begotten Son, that whoever believes in Him shall not perish, but have eternal life.")
    }

    func testVerseTextJn316NIV() async throws {
        var v = Verse(reference: Reference(book: .john, chapter: 3, verse: 16), version: .niv)
        let text = try await v.text
        XCTAssert(text == "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.")
    }

    func testVerseTextJn316KJV() async throws {
        var v = Verse(reference: Reference(book: .john, chapter: 3, verse: 16), version: .kjv)
        let text = try await v.text
        XCTAssert(text == "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.")
    }
    
    func testVerseWordsJn316() async throws {
        var v = Verse(reference: Reference(book: .genesis, chapter: 1, verse: 1), version: .esv)
        let words = try await v.words
        XCTAssert(words.count == 10)
        XCTAssert(words[0] == "In")
        XCTAssert(words[2] == "beginning")
        XCTAssert(words[6] == "heavens")
        XCTAssert(words[9] == "earth")
    }
    
    func testJson() throws {
        let ref = Verse(reference: Reference())
        let json = ref.json()
        XCTAssert(json! == "{\"verse\":1,\"chapter\":1,\"book\":\"Genesis\",\"version\":\"ESV\"}")
    }

    
}
