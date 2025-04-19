//
//  PassageTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/2/22.
//

import XCTest
@testable import SwordMinder

final class PassageTests: XCTestCase {
    
    actor MockVerseProvider: VerseProvider {
        private let mockTexts: [String: String]
        
        init(mockTexts: [String: String]) {
            self.mockTexts = mockTexts
        }
        
        func getText(for request: VerseRequest) async throws -> String {
            let id = "\(request.book.rawValue)-\(request.chapter)-\(request.verse)-\(request.version.rawValue)"
            guard let text = mockTexts[id] else {
                throw NSError(domain: "MockVerseProvider", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock verse not found for \(id)"])
            }
            return text
        }
    }
    
    override func setUp() async throws {
        Verse.provider = MockVerseProvider(mockTexts: [
            "Genesis-1-1-ESV": "In the beginning, God created the heavens and the earth.",
            "Genesis-1-1-KJV": "In the beginning God created the heaven and the earth.",
            "Genesis-1-2-KJV": "And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.",
            "Colossians-3-2-ESV": "Set your minds on things that are above, not on things that are on earth.",
            // Add more if needed for broader test coverage
        ])
    }
    // MARK: - Passage Tests
    
    func testPassageOnlyBegin() async throws {
        let passage = Passage(from: Reference(), translation: .kjv)
        let text = try await passage.text()
        XCTAssertEqual(text, "\(1.superscriptString)In the beginning God created the heaven and the earth. (KJV)")
        XCTAssertEqual(passage.referenceFormatted, "Genesis 1:1 (KJV)")
    }
    
    func testPassageRange() async throws {
        let gen11Ref = Reference()
        let gen12Ref = Reference(fromString: "Genesis 1:2")!
        let passage = Passage(from: gen11Ref, to: gen12Ref)
        XCTAssertEqual(passage.referenceFormatted, "Genesis 1:1-2 (ESV)")
    }
    
    func testPassageRangeCrossChapter() async throws {
        let gen11Ref = Reference()
        let gen215Ref = Reference(fromString: "Genesis 2:15")!
        let passage = Passage(from: gen11Ref, to: gen215Ref)
        XCTAssertEqual(passage.referenceFormatted, "Genesis 1:1-2:15 (ESV)")
    }
    
    func testPassageStartReferenceChange() throws {
        let gen11Ref = Reference()
        let gen12Ref = Reference(verse: 2)
        var passage = Passage(from: gen11Ref, to: gen12Ref)
        
        // Change verse from start reference later than end
        passage.updateReferences(start: Reference(verse: 3))
        XCTAssertEqual(passage.endReference, Reference(verse: 3))
        
        // Change chapter from start reference later than end
        passage = Passage(from: Reference(chapter: 2, verse: 10), to: Reference(chapter: 2, verse: 12)) // Genesis 2:10-12
        passage.updateReferences(start: Reference(chapter: 3))
        XCTAssertEqual(passage.endReference, Reference(chapter: 3))
        
        // Change book from start reference later than end
        passage = Passage(from: Reference(book: .joshua, chapter: 2, verse: 10), to: Reference(book: .joshua, chapter: 2, verse: 12)) // Joshua 2:10-12
        passage.updateReferences(start: Reference(book: .ezra))
        XCTAssertEqual(passage.endReference, Reference(book: .ezra))
        
    }
    
    func testPassageEndReferenceChange() throws {
        let gen110Ref = Reference(verse: 10)
        let gen112Ref = Reference(verse: 12)
        var passage = Passage(from: gen110Ref, to: gen112Ref)
        
        // Change verse from end reference earlier than start
        let newEndReference = Reference(verse: 3)
        passage.updateReferences(end: newEndReference)
        XCTAssertEqual(passage.startReference, Reference(verse: 3))
        
        // Change chapter from end reference earlier than start
        passage = Passage(from: Reference(chapter: 2, verse: 10), to: Reference(chapter: 2, verse: 12)) // Genesis 2:10-12
        let newEndReference2 = Reference(chapter: 1)
        passage.updateReferences(end: newEndReference2)
        XCTAssertEqual(passage.startReference, Reference(chapter: 1))
        
        // Change book from end reference earlier than start
        passage = Passage(from: Reference(book: .joshua, chapter: 2, verse: 10), to: Reference(book: .joshua, chapter: 2, verse: 12)) // Joshua 2:10-12
        let newEndReference3 = Reference(book: .numbers)
        passage.updateReferences(end: newEndReference3)
        XCTAssertEqual(passage.startReference, Reference(book: .numbers))
    }
    
    func testBibleWordsforPassage() async throws {
        let passage = Passage(from: Reference(), to: Reference(verse: 2), translation: .kjv) // Genesis 1:1-2
        let words = try await passage.words()
        XCTAssertEqual(words.count, 40)
        XCTAssertEqual(words[0], "In")
        XCTAssertEqual(words[2], "beginning")
        XCTAssertEqual(words[6], "heaven")
        XCTAssertEqual(words[38], "waters")
        
    }
    
    func testBiblePassageFromString() async throws {
        let passage = Passage(fromString: "Genesis 1:1")
        XCTAssertEqual(passage?.referenceFormatted, "Genesis 1:1 (ESV)")
        let passage2 = Passage(fromString: "John 3:16", version: .niv)
        XCTAssertEqual(passage2?.referenceFormatted, "John 3:16 (NIV)")
    }
    
    func testBiblePassageFromStringNil() async throws {
        let passage = Passage(fromString: "XYZ 2:3")
        XCTAssertNil(passage)
    }
    
    func testBiblePassageFromStringToString() async throws {
        let passage = Passage(fromString: "Genesis 1:1", toString: "Genesis 2:4")
        XCTAssertEqual(passage?.referenceFormatted, "Genesis 1:1-2:4 (ESV)")
    }
    
    func testBiblePassageFromStringToStringOutOfOrder() async throws {
        let passage = Passage(fromString: "Genesis 2:3", toString: "Genesis 1:1")
        XCTAssertEqual(passage?.referenceFormatted, "Genesis 2:3 (ESV)")
    }
    
    func testPassageText() async throws {
        let passage = Passage(translation: .kjv)
        let text = try await passage.text()
        XCTAssertEqual(text, "\(1.superscriptString)In the beginning God created the heaven and the earth. (KJV)")
        let gen11Ref = Reference()
        let gen12Ref = Reference(fromString: "Genesis 1:2")
        let passage2 = Passage(from: gen11Ref, to: gen12Ref, translation: .kjv)
        let text2 = try await passage2.text()
        XCTAssertEqual(text2, "\(1.superscriptString)In the beginning God created the heaven and the earth. \(2.superscriptString)And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters. (KJV)")
        let passage3 = Passage(from: Reference(fromString: "Colossians 3:2")!, translation: .esv)
        let text3 = try await passage3.text()
        XCTAssertEqual(text3, "\(2.superscriptString)Set your minds on things that are above, not on things that are on earth. (ESV)")
    }
    
    func testPassageEncode() async throws {
        let passage = Passage()
        _ = try await passage.text()
        let data = try JSONEncoder().encode(passage)
        print(String(data: data, encoding: .utf8)!)
        let passage2 = try JSONDecoder().decode(Passage.self, from: data)
        XCTAssertEqual(passage2.startReference.book, .genesis)
    }
    
}
