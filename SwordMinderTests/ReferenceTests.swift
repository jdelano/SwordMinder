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
        XCTAssertEqual(ref.book, .genesis)
        XCTAssertEqual(ref.chapter, 1)
        XCTAssertEqual(ref.verse, 1)
        
        let ref2 = Reference(book: .exodus)
        XCTAssertEqual(ref2.book, .exodus)
        XCTAssertEqual(ref2.chapter, 1)
        XCTAssertEqual(ref2.verse, 1)
        
        let ref3 = Reference(book: .exodus, chapter: 2)
        XCTAssertEqual(ref3.book, .exodus)
        XCTAssertEqual(ref3.chapter, 2)
        XCTAssertEqual(ref3.verse, 1)
        
        let ref4 = Reference(book: .exodus, chapter: 3, verse: 5)
        XCTAssertEqual(ref4.book, .exodus)
        XCTAssertEqual(ref4.chapter, 3)
        XCTAssertEqual(ref4.verse, 5)
    }
    
    func testReferenceInitBad() throws {
        let ref = Reference(book: .john, chapter: 50, verse: 1)
        XCTAssertEqual(ref.book, .john)
        XCTAssertEqual(ref.chapter, 21)
        XCTAssertEqual(ref.verse, 1)
        
        let ref2 = Reference(book: .hebrews, chapter: 1, verse: 100)
        XCTAssertEqual(ref2.book, .hebrews)
        XCTAssertEqual(ref2.chapter, 1)
        XCTAssertEqual(ref2.verse, 14)
        
        let ref3 = Reference(book: .john, chapter: -10, verse: 1)
        XCTAssertEqual(ref3.book, .john)
        XCTAssertEqual(ref3.chapter, 1)
        XCTAssertEqual(ref3.verse, 1)
        
        let ref4 = Reference(book: .hebrews, chapter: 1, verse: -5)
        XCTAssertEqual(ref4.book, .hebrews)
        XCTAssertEqual(ref4.chapter, 1)
        XCTAssertEqual(ref4.verse, 1)
        
        let ref5 = Reference(book: .hebrews, chapter: 0, verse: 0)
        XCTAssertEqual(ref5.book, .hebrews)
        XCTAssertEqual(ref5.chapter, 1)
        XCTAssertEqual(ref5.verse, 1)
    }
    
    func testReferenceInitFromDecoder() throws {
        let data = try JSONSerialization.data(withJSONObject: bibleJSON)
        let references: [Reference] = try JSONDecoder().decode([Reference].self, from: data)
        XCTAssertEqual(references.count, 2)
    }
    
    func testReferenceEncode() throws {
        let ref = Reference()
        let data = try JSONEncoder().encode(ref)
        print(String(data: data, encoding: .utf8)!)
        let ref2 = try JSONDecoder().decode(Reference.self, from: data)
        XCTAssertEqual(ref2.book, .genesis)
    }
    
    func testReferenceToString() throws {
        let ref = Reference()
        XCTAssertEqual(ref.toString(), "Genesis 1:1")
        let ref2 = Reference(book: .exodus, chapter: 3, verse: 2)
        XCTAssertEqual(ref2.toString(), "Exodus 3:2")
    }
    
    func testReferenceLessThan() throws {
        let ref = Reference()
        let ref2 = Reference(book: .exodus, chapter: 3, verse: 2)
        XCTAssertLessThan(ref, ref2)
        
        let ref3 = Reference(chapter: 2)
        let ref4 = Reference(verse: 2)
        let ref5 = Reference(book: .exodus, chapter: 3, verse: 3)
        let ref6 = Reference(book: .exodus, chapter: 2, verse: 4)
        
        XCTAssertLessThan(ref2, ref5)
        XCTAssertLessThan(ref6, ref5)
        XCTAssertLessThan(ref, ref3)
        XCTAssertLessThan(ref, ref4)
    }
    
    func testReferenceNext() throws {
        let ref = Reference()
        XCTAssertEqual(ref.next?.book, .genesis)
        XCTAssertEqual(ref.next?.chapter, 1)
        XCTAssertEqual(ref.next?.verse, 2)
        
        let ref2 = Reference(book: .revelation, chapter: 22, verse: 21)
        XCTAssertNil(ref2.next)
        
        let ref3 = Reference(book: .romans, chapter: 7, verse: 25)
        XCTAssertEqual(ref3.next?.book, .romans)
        XCTAssertEqual(ref3.next?.chapter, 8)
        XCTAssertEqual(ref3.next?.verse, 1)
        
        let ref4 = Reference(book: .acts, chapter: 28, verse: 31)
        XCTAssertEqual(ref4.next?.book, .romans)
        XCTAssertEqual(ref4.next?.chapter, 1)
        XCTAssertEqual(ref4.next?.verse, 1)
    }
    
    func testReferenceRandom() throws {
        let reference = Reference.random(in: .genesis)
        XCTAssertEqual(reference.book, .genesis)
        XCTAssertTrue((1...50).contains(reference.chapter))
        
        let ref2 = Reference.random(in: .john, chapter: 3)
        XCTAssertEqual(ref2.book, .john)
        XCTAssertEqual(ref2.chapter, 3)
        XCTAssertTrue((1...36).contains(ref2.verse))
        
        let ref3 = Reference.random(in: .genesis, chapter: 110)
        XCTAssertEqual(ref3.book, .genesis)
        XCTAssertTrue((1...50).contains(ref3.chapter))
    }
    
    func testReferenceInitFromString() throws {
        let gen11Ref = Reference(fromString: "Genesis 1:1")
        XCTAssertEqual(gen11Ref?.book, .genesis)
        XCTAssertEqual(gen11Ref?.chapter, 1)
        XCTAssertEqual(gen11Ref?.verse, 1)
        
        let ref = Reference(fromString: "1 Samuel 2:23")
        XCTAssertEqual(ref?.book, .firstSamuel)
        XCTAssertEqual(ref?.chapter, 2)
        XCTAssertEqual(ref?.verse, 23)
    }
    
    func testReferencetoString() throws {
        let gen11Ref = Reference(fromString: "Genesis 1:1")
        XCTAssertEqual(gen11Ref?.toString(), "Genesis 1:1")
        
        let john121Ref = Reference(fromString: "John 1:21")
        XCTAssertEqual(john121Ref?.toString(), "John 1:21")
        
        let firstjohn121Ref = Reference(fromString: "1 John 1:10")
        XCTAssertEqual(firstjohn121Ref?.toString(), "1 John 1:10")
    }
    
    func testReferences() throws {
        let ref = Reference(fromString: "Genesis 1:1")!
        XCTAssertEqual(ref.chapter, 1)
        XCTAssertEqual(ref.verse, 1)
        XCTAssertEqual(ref.book, .genesis)
        
        let ref2 = Reference(fromString: "1 John 2:3")!
        XCTAssertEqual(ref2.chapter, 2)
        XCTAssertEqual(ref2.verse, 3)
        XCTAssertEqual(ref2.book, .firstJohn)
        
        let ref3 = Reference(fromString: "1 Peter 5:3")!
        XCTAssertEqual(ref3.chapter, 5)
        XCTAssertEqual(ref3.verse, 3)
        XCTAssertEqual(ref3.book, .firstPeter)
        
        let ref4 = Reference(fromString: "Revelation 22:20-21")
        XCTAssertNil(ref4)
        
        let ref5 = Reference(fromString: "XYZ 3:1")
        XCTAssertNil(ref5)
    }
    
    func testBookLastChapter() throws {
        let gen = Reference(book: .genesis)
        XCTAssertEqual(gen.lastChapter, 50)
        
        let exo = Reference(book: .exodus)
        XCTAssertEqual(exo.lastChapter, 40)
        
        let psa = Reference(book: .psalms)
        XCTAssertEqual(psa.lastChapter, 150)
    }
    
    func testBookLastVerseInChapter() throws {
        var gen = Reference(book: .genesis)
        XCTAssertEqual(gen.lastVerse, 31)
        
        gen.chapter = 2
        XCTAssertEqual(gen.lastVerse, 25)
        
        gen.chapter = 49
        XCTAssertEqual(gen.lastVerse, 33)
        
        gen.chapter = 50
        XCTAssertEqual(gen.lastVerse, 26)
        
        let exo = Reference(book: .exodus)
        XCTAssertEqual(exo.lastVerse, 22)
        
        let mat = Reference(book: .matthew, chapter: 28)
        XCTAssertEqual(mat.lastVerse, 20)
    }
    
    func testChaptersMatchingBook() throws {
        XCTAssertEqual(Reference(book: .genesis).lastChapter, 50)
        XCTAssertEqual(Reference(book: .exodus).lastChapter, 40)
        XCTAssertEqual(Reference(book: .malachi).lastChapter, 4)
        XCTAssertEqual(Reference(book: .matthew).lastChapter, 28)
        XCTAssertEqual(Reference(book: .revelation).lastChapter, 22)
    }
    
    func testVerseInChapterCount() throws {
        let genesis = Reference(book: .genesis, chapter: 1)
        XCTAssertEqual(genesis.lastVerse, 31)
        
        let exodus = Reference(book: .exodus, chapter: 5)
        XCTAssertEqual(exodus.lastVerse, 23)
        
        let psalms = Reference(book: .psalms, chapter: 119)
        XCTAssertEqual(psalms.lastVerse, 176)
        
        let malachi = Reference(book: .malachi, chapter: 4)
        XCTAssertEqual(malachi.lastVerse, 6)
        
        let matthew = Reference(book: .matthew, chapter: 28)
        XCTAssertEqual(matthew.lastVerse, 20)
        
        let romans = Reference(book: .romans, chapter: 12)
        XCTAssertEqual(romans.lastVerse, 21)
        
        let revelation = Reference(book: .revelation, chapter: 22)
        XCTAssertEqual(revelation.lastVerse, 21)
    }
}
