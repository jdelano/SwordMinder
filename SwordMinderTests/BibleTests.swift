//
//  BibleTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 10/9/22.
//

import XCTest
@testable import SwordMinder

final class BibleTests: XCTestCase {

    private var bibleJSON: String = """
    [
      {
        "book": "Genesis",
        "chapter": 1,
        "verse": 1,
        "text": "In the beginning God created the heaven and the earth."
      },
      {
        "book": "Genesis",
        "chapter": 1,
        "verse": 2,
        "text": "And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters."
      }
    ]
    """
    private let kjvURL: URL = Bundle.main.url(forResource: "kjv", withExtension: "json")!
    private var verses: [Bible.Verse] = []
    
    override func setUpWithError() throws {
        self.verses = try JSONDecoder().decode([Bible.Verse].self, from: bibleJSON.data(using:.utf8)!)
    }

    // MARK: - Verse Tests
    
    func testVerseDecoding() throws {
        XCTAssert(verses.count == 2)
        let gen11 = verses.first!
        XCTAssert(gen11.reference.book == "Genesis")
        XCTAssert(gen11.reference.chapter == 1)
        XCTAssert(gen11.reference.verse == 1)
    }

    func testVersetoString() throws {
        let gen11 = verses.first!
        XCTAssert(gen11.toString() == "\(gen11.reference.verse.superscriptString)\(gen11.text)")
    }
    
    // MARK: - Reference Tests
    
    func testReferenceInitFromString() throws {
        let gen11Ref = Bible.Reference(fromString: "Genesis 1:1")
        XCTAssert(gen11Ref.book == "Genesis")
        XCTAssert(gen11Ref.chapter == 1)
        XCTAssert(gen11Ref.verse == 1)
    }
    
    func testReferenceInitFromParts() throws {
        let gen11Ref = Bible.Reference(book: "Genesis", chapter: 1, verse: 1)
        XCTAssert(gen11Ref.book == "Genesis")
        XCTAssert(gen11Ref.chapter == 1)
        XCTAssert(gen11Ref.verse == 1)
    }
    
    func testReferencetoString() throws {
        let gen11Ref = Bible.Reference(book: "Genesis", chapter: 1, verse: 1)
        XCTAssert(gen11Ref.toString() == "Genesis 1:1")
    }

    // MARK: - Bible Tests
    
    func testChapterCount() throws {
        XCTAssert(Bible.chapters(in: "Genesis")! == 50)
        XCTAssert(Bible.chapters(in: "Exodus")! == 40)
        XCTAssert(Bible.chapters(in: "Malachi")! == 4)
        XCTAssert(Bible.chapters(in: "Matthew")! == 28)
        XCTAssert(Bible.chapters(in: "Revelation")! == 22)
    }
    
    func testVerseinChapterCount() throws {
        XCTAssert(Bible.verses(in: "Genesis", chapter: 1)! == 31)
        XCTAssert(Bible.verses(in: "Exodus", chapter: 5)! == 23)
        XCTAssert(Bible.verses(in: "Malachi", chapter: 4)! == 6)
        XCTAssert(Bible.verses(in: "Psalms", chapter: 119)! == 176)
        XCTAssert(Bible.verses(in: "Matthew", chapter: 28)! == 20)
        XCTAssert(Bible.verses(in: "Romans", chapter: 12)! == 21)
        XCTAssert(Bible.verses(in: "Revelation", chapter: 22)! == 21)
    }
    
    // MARK: - Passage Tests
    
    func testBiblePassageOnlyBegin() throws {
        let bible = Bible(translation: .kjv)
        let gen11Ref = Bible.Reference(book: "Genesis", chapter: 1, verse: 1)
        let passage = bible.passage(from: gen11Ref)
        XCTAssert(passage?.text == verses.first!.toString())
        XCTAssert(passage?.reference == "Genesis 1:1")
    }
    
    func testBiblePassageRange() throws {
        let bible = Bible(translation: .kjv)
        let gen11Ref = Bible.Reference(book: "Genesis", chapter: 1, verse: 1)
        let gen12Ref = Bible.Reference(book: "Genesis", chapter: 1, verse: 2)
        let passage = bible.passage(from: gen11Ref, to: gen12Ref)
        XCTAssert(passage?.text == verses.first!.toString() + " " + verses[1].toString())
        XCTAssert(passage?.reference == "Genesis 1:1-2")
    }
    
    func testBiblePassageRangeCrossChapter() throws {
        let bible = Bible(translation: .kjv)
        let gen11Ref = Bible.Reference(book: "Genesis", chapter: 1, verse: 1)
        let gen215Ref = Bible.Reference(book: "Genesis", chapter: 2, verse: 15)
        let passage = bible.passage(from: gen11Ref, to: gen215Ref)
        XCTAssert(passage?.reference == "Genesis 1:1-2:15")
    }
}
