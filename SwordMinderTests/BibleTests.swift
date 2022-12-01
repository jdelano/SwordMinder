//
//  BibleTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 10/9/22.
//

import XCTest
@testable import SwordMinder

final class BibleTests: XCTestCase {

    // MARK: - Bible Tests
    
    func testBibleInit() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        XCTAssert(bible.books(matching: "Gen").first!.chapters.count == 50)
        var csbBible = Bible(translation: .csb)
        await csbBible.initBible()
        XCTAssert(csbBible.passage(fromString: "Gen 1:1") == nil) // Because CSB isn't implemented yet
    }
    
    func testBibleBookNames() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let bookNames = bible.bookNames
        XCTAssert(bookNames.count == 66)
        XCTAssert(bookNames[0] == "Genesis")
        XCTAssert(bookNames[1] == "Exodus")
        XCTAssert(bookNames[38] == "Malachi")
        XCTAssert(bookNames[39] == "Matthew")
        XCTAssert(bookNames[65] == "Revelation")
    }
    
    
    func testBibleReferences() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let ref = bible.reference(fromString: "Gen 1:1")!
        XCTAssert(ref.chapter == 1)
        XCTAssert(ref.verse == 1)
        XCTAssert(ref.book.name == "Genesis")
        let ref2 = bible.reference(fromString: "First John 2:3")!
        XCTAssert(ref2.chapter == 2)
        XCTAssert(ref2.verse == 3)
        XCTAssert(ref2.book.name == "1 John")
        let ref3 = bible.reference(fromString: "1st Pet 5:3")!
        XCTAssert(ref3.chapter == 5)
        XCTAssert(ref3.verse == 3)
        XCTAssert(ref3.book.name == "1 Peter")
        let ref4 = bible.reference(fromString: "Rev 22:20-21")
        XCTAssert(ref4 == nil)
        let ref5 = bible.reference(fromString: "XYZ 3:1")
        XCTAssert(ref5 == nil)
    }
    
    func testBibleReferenceBookChapterVerse() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let ref = bible.reference(book: bible.books(matching: "Gen").first!, chapter: 1, verse: 3)
        XCTAssert(ref.book.name == "Genesis")
        XCTAssert(ref.chapter == 1)
        XCTAssert(ref.verse == 3)
    }
    
    func testBibleReferenceMatching() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let ref = bible.reference(matching: "Gen", chapter: 1, verse: 3)!
        XCTAssert(ref.book.name == "Genesis")
        XCTAssert(ref.chapter == 1)
        XCTAssert(ref.verse == 3)
        let ref2 = bible.reference(matching: "XYZ", chapter: 3, verse: 2)
        XCTAssert(ref2 == nil)
    }

    func testBibleBookLookup() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let books = bible.books(matching: "joh")
        XCTAssert(books.count == 4)
    }
    
    func testChaptersInBook() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let genesis = bible.books(matching: "Gen").first!
        XCTAssert(bible.chapters(in: genesis).count == 50)
        let exodus = bible.books(matching: "Exo").first!
        XCTAssert(bible.chapters(in: exodus).count == 40)
        let malachi = bible.books(matching: "Mal").first!
        XCTAssert(bible.chapters(in: malachi).count == 4)
        let matthew = bible.books(matching: "Matt").first!
        XCTAssert(bible.chapters(in: matthew).count == 28)
        let revelation = bible.books(matching: "Rev").first!
        XCTAssert(bible.chapters(in: revelation).count == 22)
    }
    
    func testChaptersMatchingBook() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        XCTAssert(bible.chapters(matching: "Gen").count == 50)
        XCTAssert(bible.chapters(matching: "Exo").count == 40)
        XCTAssert(bible.chapters(matching: "Mal").count == 4)
        XCTAssert(bible.chapters(matching: "Matt").count == 28)
        XCTAssert(bible.chapters(matching: "Rev").count == 22)
        XCTAssert(bible.chapters(matching: "XYZ").isEmpty)
    }

    func testVerseInChapterCount() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let genesis = bible.books(matching: "Gen").first!
        XCTAssert(bible.verses(in: genesis, chapter: 1).count == 31)
        let exodus = bible.books(matching: "Exo").first!
        XCTAssert(bible.verses(in: exodus, chapter: 5).count == 23)
        let psalms = bible.books(matching: "Psa").first!
        XCTAssert(bible.verses(in: psalms, chapter: 119).count == 176)
        let malachi = bible.books(matching: "Mal").first!
        XCTAssert(bible.verses(in: malachi, chapter: 4).count == 6)
        let matthew = bible.books(matching: "Matt").first!
        XCTAssert(bible.verses(in: matthew, chapter: 28).count == 20)
        let romans = bible.books(matching: "Rom").first!
        XCTAssert(bible.verses(in: romans, chapter: 12).count == 21)
        let revelation = bible.books(matching: "Rev").first!
        XCTAssert(bible.verses(in: revelation, chapter: 22).count == 21)
    }
    
    func testVerseMatchingBookChapterCount() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        XCTAssert(bible.verses(matching: "Gen", chapter: 1).count == 31)
        XCTAssert(bible.verses(matching: "Exo", chapter: 5).count == 23)
        XCTAssert(bible.verses(matching: "Psa", chapter: 119).count == 176)
        XCTAssert(bible.verses(matching: "Mal", chapter: 4).count == 6)
        XCTAssert(bible.verses(matching: "Matt", chapter: 28).count == 20)
        XCTAssert(bible.verses(matching: "Rom", chapter: 12).count == 21)
        XCTAssert(bible.verses(matching: "Rev", chapter: 22).count == 21)
        XCTAssert(bible.verses(matching: "XYZ", chapter: 1).isEmpty)
        XCTAssert(bible.verses(matching: "Gen", chapter: 51).isEmpty)
    }

    
    // MARK: - Verse Tests
    
    func testVersesInBook() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let gen = bible.books(matching: "Genesis").first!
        XCTAssert(bible.verses(in: gen, chapter: 1).count == 31)
    }
    
    func testVersetoString() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let gen11 = bible.passage(fromString: "Genesis 1:1")!
        XCTAssert(gen11.text == "\(1.superscriptString)In the beginning God created the heaven and the earth.")
    }

    
    // MARK: - Reference Tests
    
    func testReferenceInitFromString() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let gen11Ref = bible.reference(fromString: "Genesis 1:1")
        XCTAssert(gen11Ref?.book.name == "Genesis")
        XCTAssert(gen11Ref?.chapter == 1)
        XCTAssert(gen11Ref?.verse == 1)
    }

    func testReferencetoString() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let gen11Ref = bible.reference(fromString: "Genesis 1:1")
        XCTAssert(gen11Ref?.toString() == "Genesis 1:1")
        let john121Ref = bible.reference(fromString: "john 1:21")
        XCTAssert(john121Ref?.toString() == "John 1:21")
        let firstjohn121Ref = bible.reference(fromString: "1st john 1:21")
        XCTAssert(firstjohn121Ref?.toString() == "1 John 1:21")
    }

    // MARK: - Passage Tests

    func testBiblePassageOnlyBegin() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let gen11Ref = bible.reference(fromString: "Genesis 1:1")!
        let passage = bible.passage(from: gen11Ref)
        XCTAssert(passage?.text == "\(1.superscriptString)In the beginning God created the heaven and the earth.")
        XCTAssert(passage?.reference == "Genesis 1:1")
    }

    func testBiblePassageRange() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let gen11Ref = bible.reference(fromString: "Genesis 1:1")!
        let gen12Ref = bible.reference(fromString: "Genesis 1:2")!
        let passage = bible.passage(from: gen11Ref, to: gen12Ref)
        XCTAssert(passage?.text == "\(1.superscriptString)In the beginning God created the heaven and the earth. \(2.superscriptString)And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.")
        XCTAssert(passage?.reference == "Genesis 1:1-2")
    }

    func testBiblePassageBadReference() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let gen511Ref = bible.reference(fromString: "Genesis 51:1")!
        let gen512Ref = bible.reference(fromString: "Genesis 51:2")!
        let passage = bible.passage(from: gen511Ref, to: gen512Ref)
        XCTAssert(passage == nil)
    }

    func testBiblePassageRangeCrossChapter() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let gen11Ref = bible.reference(fromString: "Genesis 1:1")!
        let gen215Ref = bible.reference(fromString: "Genesis 2:15")!
        let passage = bible.passage(from: gen11Ref, to: gen215Ref)
        XCTAssert(passage?.reference == "Genesis 1:1-2:15")
    }

    
    func testBiblePassageFromString() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let passage = bible.passage(fromString: "Gen 1:1")
        XCTAssert(passage?.reference == "Genesis 1:1")
    }

    
    func testBiblePassageFromStringToString() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let passage = bible.passage(fromString: "Gen 1:1", toString: "Gen 2:4")
        XCTAssert(passage?.reference == "Genesis 1:1-2:4")
    }

    
    func testBiblePassageFromStringToStringOutOfOrder() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let passage = bible.passage(fromString: "Gen 2:3", toString: "Gen 1:1")
        XCTAssert(passage?.reference == "Genesis 2:3")
    }
    
    
    func testBibleReferenceFromString() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        let ref = bible.reference(fromString: "I Sam 2:23")
        XCTAssert(ref?.book.name == "1 Samuel")
        XCTAssert(ref?.chapter == 2)
        XCTAssert(ref?.verse == 23)
    }


    func testBibleBookMatching() async throws {
        var bible = Bible(translation: .kjv)
        await bible.initBible()
        // 8 books with a "first" prefix (1 Samuel, 1 Kings, 1 Chronicles, 1 Corinthians, 1 Thessalonians, 1 Timothy, 1 Peter, 1 John)
        XCTAssert(bible.books(matching: "1").count == 8)
        // 4 books with Jo in them (Joshua, Job, Joel, Jonah, John, 1, 2, 3 John)
        XCTAssert(bible.books(matching: "Jo").count == 8)
        XCTAssert(bible.books(matching: "Rom").count == 1)
    }    
}
