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
            "version": "ESV"
        ],
        [
            "book": "Genesis",
            "chapter": 1,
            "verse": 2,
            "version": "ESV"
        ]
    ]

    func testReferenceInit() throws {
        let ref = Reference()
        XCTAssert(ref.book == .genesis)
        XCTAssert(ref.chapter == 1)
        XCTAssert(ref.verse == 1)

        let ref2 = Reference(book: .exodus)
        XCTAssert(ref2.book == .exodus)
        XCTAssert(ref2.chapter == 1)
        XCTAssert(ref2.verse == 1)
        
        let ref3 = Reference(book: .exodus, chapter: 2)
        XCTAssert(ref3.book == .exodus)
        XCTAssert(ref3.chapter == 2)
        XCTAssert(ref3.verse == 1)

        let ref4 = Reference(book: .exodus, chapter: 3, verse: 5)
        XCTAssert(ref4.book == .exodus)
        XCTAssert(ref4.chapter == 3)
        XCTAssert(ref4.verse == 5)
    }
    
    
    func testReferenceInitBad() throws {
        let ref = Reference(book: .john, chapter: 50, verse: 1)
        XCTAssert(ref.book == .john)
        XCTAssert(ref.chapter == 1)
        XCTAssert(ref.verse == 1)
        let ref2 = Reference(book: .hebrews, chapter: 1, verse: 100)
        XCTAssert(ref2.book == .hebrews)
        XCTAssert(ref2.chapter == 1)
        XCTAssert(ref2.verse == 1)
        let ref3 = Reference(book: .john, chapter: -10, verse: 1)
        XCTAssert(ref3.book == .john)
        XCTAssert(ref3.chapter == 1)
        XCTAssert(ref3.verse == 1)
        let ref4 = Reference(book: .hebrews, chapter: 1, verse: -5)
        XCTAssert(ref4.book == .hebrews)
        XCTAssert(ref4.chapter == 1)
        XCTAssert(ref4.verse == 1)
        let ref5 = Reference(book: .hebrews, chapter: 0, verse: 0)
        XCTAssert(ref5.book == .hebrews)
        XCTAssert(ref5.chapter == 1)
        XCTAssert(ref5.verse == 1)
    }
    
    func testReferenceInitFromDecoder() throws {
        let data = try JSONSerialization.data(withJSONObject: bibleJSON)
        let references: [Reference] = try JSONDecoder().decode([Reference].self, from: data)
        XCTAssert(references.count == 2)
    }
    
    func testReferenceEncode() throws {
        let ref = Reference()
        let data = try JSONEncoder().encode(ref)
        print(String(data: data, encoding: .utf8)!)
        let ref2 = try JSONDecoder().decode(Reference.self, from: data)
        XCTAssert(ref2.book == .genesis)
    }

    func testReferenceToString() throws {
        let ref = Reference()
        XCTAssert(ref.toString() == "Genesis 1:1")
        let ref2 = Reference(book: .exodus, chapter: 3, verse: 2)
        XCTAssert(ref2.toString() == "Exodus 3:2")
    }
    
    func testReferenceLessThan() throws {
        let ref = Reference()
        let ref2 = Reference(book: .exodus, chapter: 3, verse: 2)
        XCTAssert(ref < ref2)
        let ref3 = Reference(chapter: 2)
        let ref4 = Reference(verse: 2)
        let ref5 = Reference(book: .exodus, chapter: 3, verse: 3)
        let ref6 = Reference(book: .exodus, chapter: 2, verse: 4)
        XCTAssert(ref2 < ref5)
        XCTAssert(ref6 < ref5)
        XCTAssert(ref < ref3)
        XCTAssert(ref < ref4)
    }
    
    func testReferenceNext() throws {
        let ref = Reference()
        XCTAssert(ref.next!.chapter == 1)
        XCTAssert(ref.next!.verse == 2)
        XCTAssert(ref.next!.book == .genesis)
        let ref2 = Reference(book: .revelation, chapter: 22, verse: 21)
        XCTAssert(ref2.next == nil)
        let ref3 = Reference(book: .romans, chapter: 7, verse: 25)
        XCTAssert(ref3.next!.chapter == 8)
        XCTAssert(ref3.next!.verse == 1)
        XCTAssert(ref3.next!.book == .romans)
        let ref4 = Reference(book: .acts, chapter: 28, verse: 31)
        XCTAssert(ref4.next!.chapter == 1)
        XCTAssert(ref4.next!.verse == 1)
        XCTAssert(ref4.next!.book == .romans)
    }
 
    func testReferenceRandom() async throws {
        let reference = Reference.random(in: .genesis)
        XCTAssert(reference.book == .genesis)
        XCTAssert(reference.chapter >= 1 && reference.chapter <= 50)
        let ref2 = Reference.random(in: .john, chapter: 3)
        XCTAssert(ref2.book == .john)
        XCTAssert(ref2.chapter == 3)
        XCTAssert(ref2.verse >= 1 && ref2.verse <= 36)
        let ref3 = Reference.random(in: .genesis, chapter: 110)
        XCTAssert(ref3.book == .genesis)
        XCTAssert(ref3.chapter >= 1 && ref3.chapter <= 50)
    }
    
    func testReferenceInitFromString() async throws {
        let gen11Ref = Reference(fromString: "Genesis 1:1")
        XCTAssert(gen11Ref?.book == .genesis)
        XCTAssert(gen11Ref?.chapter == 1)
        XCTAssert(gen11Ref?.verse == 1)
        let ref = Reference(fromString: "1 Samuel 2:23")
        XCTAssert(ref?.book == .firstSamuel)
        XCTAssert(ref?.chapter == 2)
        XCTAssert(ref?.verse == 23)
    }

    func testReferencetoString() async throws {
        let gen11Ref = Reference(fromString: "Genesis 1:1")
        XCTAssert(gen11Ref?.toString() == "Genesis 1:1")
        let john121Ref = Reference(fromString: "John 1:21")
        XCTAssert(john121Ref?.toString() == "John 1:21")
        let firstjohn121Ref = Reference(fromString: "1 John 1:10")
        XCTAssert(firstjohn121Ref?.toString() == "1 John 1:10")
    }
    
    func testReferences() async throws {
        let ref = Reference(fromString: "Genesis 1:1")!
        XCTAssert(ref.chapter == 1)
        XCTAssert(ref.verse == 1)
        XCTAssert(ref.book == .genesis)
        let ref2 = Reference(fromString: "1 John 2:3")!
        XCTAssert(ref2.chapter == 2)
        XCTAssert(ref2.verse == 3)
        XCTAssert(ref2.book == .firstJohn)
        let ref3 = Reference(fromString: "1 Peter 5:3")!
        XCTAssert(ref3.chapter == 5)
        XCTAssert(ref3.verse == 3)
        XCTAssert(ref3.book == .firstPeter)
        let ref4 = Reference(fromString: "Revelation 22:20-21")
        XCTAssert(ref4 == nil)
        let ref5 = Reference(fromString: "XYZ 3:1")
        XCTAssert(ref5 == nil)
    }
    
    func testBookLastChapter() throws {
        let gen = Reference(book: .genesis)
        XCTAssert(gen.lastChapter == 50)
        let exo = Reference(book: .exodus)
        XCTAssert(exo.lastChapter == 40)
        let psa = Reference(book: .psalms)
        XCTAssert(psa.lastChapter == 150)
    }
    
    func testBookLastVerseInChapter() throws {
        var gen = Reference(book: .genesis)
        XCTAssert(gen.lastVerse == 31)
        gen.chapter = 2
        XCTAssert(gen.lastVerse == 25)
        gen.chapter = 49
        XCTAssert(gen.lastVerse == 33)
        gen.chapter = 50
        XCTAssert(gen.lastVerse == 26)
        let exo = Reference(book: .exodus)
        XCTAssert(exo.lastVerse == 22)
        let mat = Reference(book: .matthew, chapter: 28)
        XCTAssert(mat.lastVerse == 20)
    }
    
    
    func testChaptersMatchingBook() async throws {
        XCTAssert(Reference(book: .genesis).lastChapter == 50)
        XCTAssert(Reference(book: .exodus).lastChapter == 40)
        XCTAssert(Reference(book: .malachi).lastChapter == 4)
        XCTAssert(Reference(book: .matthew).lastChapter == 28)
        XCTAssert(Reference(book: .revelation).lastChapter == 22)
    }
    
    func testVerseInChapterCount() async throws {
        let genesis = Reference(book: .genesis, chapter: 1)
        XCTAssert(genesis.lastVerse == 31)
        let exodus = Reference(book: .exodus, chapter: 5)
        XCTAssert(exodus.lastVerse == 23)
        let psalms = Reference(book: .psalms, chapter: 119)
        XCTAssert(psalms.lastVerse == 176)
        let malachi = Reference(book: .malachi, chapter: 4)
        XCTAssert(malachi.lastVerse == 6)
        let matthew = Reference(book: .matthew, chapter: 28)
        XCTAssert(matthew.lastVerse == 20)
        let romans = Reference(book: .romans, chapter: 12)
        XCTAssert(romans.lastVerse == 21)
        let revelation = Reference(book: .revelation, chapter: 22)
        XCTAssert(revelation.lastVerse == 21)
    }
}
