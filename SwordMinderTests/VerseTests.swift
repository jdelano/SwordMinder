//
//  VerseTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/2/22.
//

import XCTest
@testable import SwordMinder

final class VerseTests: XCTestCase {

    let bibleJSON = [
        [
            "book": "Genesis",
            "chapter": 1,
            "verse": 1,
            "text": "In the beginning God created the heaven and the earth."
        ],
        [
            "book": "Genesis",
            "chapter": 1,
            "verse": 2,
            "text": "And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters."
        ]
    ]
    

    func testVerseInit() throws {
        let data = try! JSONSerialization.data(withJSONObject: bibleJSON)
        let verses: [Verse] = try! JSONDecoder().decode([Verse].self, from: data)
        XCTAssert(verses.count == 2)
    }

    func testVerseToString() throws {
        let data = try! JSONSerialization.data(withJSONObject: bibleJSON)
        let verses: [Verse] = try! JSONDecoder().decode([Verse].self, from: data)
        XCTAssert(verses[0].toString() == "\(1.superscriptString)In the beginning God created the heaven and the earth.")
    }
    
}
