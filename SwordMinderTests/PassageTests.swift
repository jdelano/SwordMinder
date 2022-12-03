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
        var bible = Bible()
        await bible.initBible()
        let passage = Passage()
        XCTAssert(bible.text(for: passage) == "\(1.superscriptString)In the beginning God created the heaven and the earth.")
        XCTAssert(passage.referenceFormatted == "Genesis 1:1")
    }
    
    func testPassageRange() async throws {
        var bible = Bible()
        await bible.initBible()
        let gen11Ref = Reference()
        let gen12Ref = bible.reference(fromString: "Genesis 1:2")!
        let passage = Passage(from: gen11Ref, to: gen12Ref)
        XCTAssert(passage.referenceFormatted == "Genesis 1:1-2")
    }
    
    func testPassageBadReference() async throws {
        var bible = Bible()
        await bible.initBible()
        let gen511Ref = bible.reference(fromString: "Genesis 51:1")!
        let gen512Ref = bible.reference(fromString: "Genesis 51:2")!
        let passage = Passage(from: gen511Ref, to: gen512Ref)
        XCTAssert(bible.text(for: passage) == "")
    }
    
    func testPassageRangeCrossChapter() async throws {
        var bible = Bible()
        await bible.initBible()
        let gen11Ref = Reference()
        let gen215Ref = bible.reference(fromString: "Genesis 2:15")!
        let passage = Passage(from: gen11Ref, to: gen215Ref)
        XCTAssert(passage.referenceFormatted == "Genesis 1:1-2:15")
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
        passage = Passage(from: Reference(book: Book(named: "Joshua")!, chapter: 2, verse: 10), to: Reference(book: Book(named: "Joshua")!, chapter: 2, verse: 12)) // Joshua 2:10-12
        passage.startReference = Reference(book: Book(named: "Ezra")!)
        XCTAssert(passage.endReference == Reference(book: Book(named: "Ezra")!))

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
        passage = Passage(from: Reference(book: Book(named: "Joshua")!, chapter: 2, verse: 10), to: Reference(book: Book(named: "Joshua")!, chapter: 2, verse: 12)) // Joshua 2:10-12
        passage.endReference = Reference(book: Book(named: "Numbers")!)
        XCTAssert(passage.startReference == Reference(book: Book(named: "Numbers")!))

    }

}
