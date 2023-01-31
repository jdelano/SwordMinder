//
//  PassageTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/2/22.
//

import XCTest
@testable import SwordMinder

final class PassageTests: XCTestCase {

    // MARK: - Passage Tests
    
    func testPassageOnlyBegin() async throws {
        var passage = Passage(from: Reference(), version: .kjv)
        let text = try await passage.text
        XCTAssert(text == "\(1.superscriptString)In the beginning God created the heaven and the earth. (KJV)")
        XCTAssert(passage.referenceFormatted == "Genesis 1:1 (KJV)")
    }
    
    func testPassageRange() async throws {
        let gen11Ref = Reference()
        let gen12Ref = Reference(fromString: "Genesis 1:2")!
        let passage = Passage(from: gen11Ref, to: gen12Ref)
        XCTAssert(passage.referenceFormatted == "Genesis 1:1-2 (ESV)")
    }
        
    func testPassageRangeCrossChapter() async throws {
        let gen11Ref = Reference()
        let gen215Ref = Reference(fromString: "Genesis 2:15")!
        let passage = Passage(from: gen11Ref, to: gen215Ref)
        XCTAssert(passage.referenceFormatted == "Genesis 1:1-2:15 (ESV)")
    }
    
    func testPassageStartReferenceChange() throws {
        let gen11Ref = Reference()
        let gen12Ref = Reference(verse: 2)
        var passage = Passage(from: gen11Ref, to: gen12Ref)
        
        // Change verse from start reference later than end
        passage.startReference = Reference(verse: 3)
        XCTAssert(passage.endReference == Reference(verse: 3))

        // Change chapter from start reference later than end
        passage = Passage(from: Reference(chapter: 2, verse: 10), to: Reference(chapter: 2, verse: 12)) // Genesis 2:10-12
        passage.startReference = Reference(chapter: 3)
        XCTAssert(passage.endReference == Reference(chapter: 3))
        
        // Change book from start reference later than end
        passage = Passage(from: Reference(book: .joshua, chapter: 2, verse: 10), to: Reference(book: .joshua, chapter: 2, verse: 12)) // Joshua 2:10-12
        passage.startReference = Reference(book: .ezra)
        XCTAssert(passage.endReference == Reference(book: .ezra))

    }
    
    func testPassageEndReferenceChange() throws {
        let gen110Ref = Reference(verse: 10)
        let gen112Ref = Reference(verse: 12)
        var passage = Passage(from: gen110Ref, to: gen112Ref)
        
        // Change verse from end reference earlier than start
        passage.endReference = Reference(verse: 3)
        XCTAssert(passage.startReference == Reference(verse: 3))

        // Change chapter from end reference earlier than start
        passage = Passage(from: Reference(chapter: 2, verse: 10), to: Reference(chapter: 2, verse: 12)) // Genesis 2:10-12
        passage.endReference = Reference(chapter: 1)
        XCTAssert(passage.startReference == Reference(chapter: 1))
        
        // Change book from end reference earlier than start
        passage = Passage(from: Reference(book: .joshua, chapter: 2, verse: 10), to: Reference(book: .joshua, chapter: 2, verse: 12)) // Joshua 2:10-12
        passage.endReference = Reference(book: .numbers)
        XCTAssert(passage.startReference == Reference(book: .numbers))

    }
    
    func testBibleWordsforPassage() async throws {
        var passage = Passage(from: Reference(), to: Reference(verse: 2), version: .kjv) // Genesis 1:1-2
        let words = try await passage.words
        XCTAssert(words.count == 40)
        XCTAssert(words[0] == "In")
        XCTAssert(words[2] == "beginning")
        XCTAssert(words[6] == "heaven")
        XCTAssert(words[38] == "waters")
        
    }
    
    func testBiblePassageFromString() async throws {
        let passage = Passage(fromString: "Genesis 1:1")
        XCTAssert(passage?.referenceFormatted == "Genesis 1:1 (ESV)")
    }
    
    func testBiblePassageFromStringNil() async throws {
        let passage = Passage(fromString: "XYZ 2:3")
        XCTAssert(passage == nil)
    }
    
    func testBiblePassageFromStringToString() async throws {
        let passage = Passage(fromString: "Genesis 1:1", toString: "Genesis 2:4")
        XCTAssert(passage?.referenceFormatted == "Genesis 1:1-2:4 (ESV)")
    }
    
    func testBiblePassageFromStringToStringOutOfOrder() async throws {
        let passage = Passage(fromString: "Genesis 2:3", toString: "Genesis 1:1")
        XCTAssert(passage?.referenceFormatted == "Genesis 2:3 (ESV)")
    }

    func testPassageText() async throws {
        var passage = Passage(version: .kjv)
        let text = try await passage.text
        XCTAssert(text == "\(1.superscriptString)In the beginning God created the heaven and the earth. (KJV)")
        let gen11Ref = Reference()
        let gen12Ref = Reference(fromString: "Genesis 1:2")
        var passage2 = Passage(from: gen11Ref, to: gen12Ref, version: .kjv)
        let text2 = try await passage2.text
        XCTAssert(text2 == "\(1.superscriptString)In the beginning God created the heaven and the earth. \(2.superscriptString)And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters. (KJV)")
        var passage3 = Passage(from: Reference(fromString: "Colossians 3:2")!, version: .esv)
        let text3 = try await passage3.text
        XCTAssert(text3 == "\(2.superscriptString)Set your minds on things that are above, not on things that are on earth. (ESV)")
    }

    func testPassageEncode() async throws {
        var passage = Passage()
        _ = try await passage.text
        let data = try JSONEncoder().encode(passage)
        print(String(data: data, encoding: .utf8)!)
        let passage2 = try JSONDecoder().decode(Passage.self, from: data)
        XCTAssert(passage2.startReference.book == .genesis)
    }
    
    func testPassageTranslationModify() async throws {
        var passage = Passage()
        _ = try await passage.text
        XCTAssert(passage.versesLoaded == true)
        passage.version = .kjv
        XCTAssert(passage.versesLoaded == false)
        _ = try await passage.text
        XCTAssert(passage.versesLoaded == true)
    }
    
}
