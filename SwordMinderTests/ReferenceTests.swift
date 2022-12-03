//
//  ReferenceTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/2/22.
//

import XCTest
@testable import SwordMinder

final class ReferenceTests: XCTestCase {
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

    func testReferenceInit() throws {
        let ref = Reference()
        XCTAssert(ref.book == Book(named: "Genesis"))
        XCTAssert(ref.chapter == 1)
        XCTAssert(ref.verse == 1)

        let ref2 = Reference(book: Book(named: "Exodus")!)
        XCTAssert(ref2.book == Book(named: "Exodus"))
        XCTAssert(ref2.chapter == 1)
        XCTAssert(ref2.verse == 1)
        
        let ref3 = Reference(book: Book(named: "Exodus")!, chapter: 2)
        XCTAssert(ref3.book == Book(named: "Exodus"))
        XCTAssert(ref3.chapter == 2)
        XCTAssert(ref3.verse == 1)

        let ref4 = Reference(book: Book(named: "Exodus")!, chapter: 3, verse: 5)
        XCTAssert(ref4.book == Book(named: "Exodus"))
        XCTAssert(ref4.chapter == 3)
        XCTAssert(ref4.verse == 5)
    }
    
    func testReferenceInitFromDecoder() throws {
        let data = try! JSONSerialization.data(withJSONObject: bibleJSON)
        let references: [Reference] = try! JSONDecoder().decode([Reference].self, from: data)
        XCTAssert(references.count == 2)
    }
    
    func testReferenceEncode() throws {
        let ref = Reference()
        let data = try JSONEncoder().encode(ref)
        print(String(data: data, encoding: .utf8)!)
        let ref2 = try JSONDecoder().decode(Reference.self, from: data)
        XCTAssert(ref2.book.name == "Genesis")
    }

    func testReferenceToString() throws {
        let ref = Reference()
        XCTAssert(ref.toString() == "Genesis 1:1")
        let ref2 = Reference(book: Book(named: "Exodus")!, chapter: 3, verse: 2)
        XCTAssert(ref2.toString() == "Exodus 3:2")
    }
    
    func testReferenceLessThan() throws {
        let ref = Reference()
        let ref2 = Reference(book: Book(named: "Exodus")!, chapter: 3, verse: 2)
        XCTAssert(ref < ref2)
        let ref3 = Reference(chapter: 2)
        let ref4 = Reference(verse: 2)
        let ref5 = Reference(book: Book(named: "Exodus")!, chapter: 3, verse: 3)
        let ref6 = Reference(book: Book(named: "Exodus")!, chapter: 2, verse: 4)
        XCTAssert(ref2 < ref5)
        XCTAssert(ref6 < ref5)
        XCTAssert(ref < ref3)
        XCTAssert(ref < ref4)
    }
}
