//
//  BookTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/2/22.
//

import XCTest
@testable import SwordMinder

final class BookTests: XCTestCase {
    
    // MARK: - Book Tests
    
    func testBookInit() throws {
        var book = Book(rawValue: "Genesis")!
        XCTAssertEqual(book, .genesis)
        
        book = Book.joshua
        XCTAssertEqual(book, .joshua)
        
        let xyzBook = Book(rawValue: "XYZBook")
        XCTAssertNil(xyzBook)
        
        let firstJohn = Book.firstJohn
        XCTAssertEqual(firstJohn, .firstJohn)
    }
    
    
    func testBookLessThan() throws {
        let book1 = Book.genesis
        let book2 = Book.exodus
        XCTAssert(book1 < book2)
        XCTAssertFalse(book2 < book1)
    }
    
    func testBookGreaterThan() throws {
        let book1 = Book.genesis
        let book2 = Book.exodus
        XCTAssert(book2 > book1)
        XCTAssertFalse(book1 > book2)
    }
    
    func testBookEqualTo() throws {
        let book1 = Book.genesis
        let book2 = Book.genesis
        XCTAssertEqual(book1, book2)
    }
    
    func testBookChangeName() throws {
        var book = Book.genesis
        book = .joshua
        XCTAssertEqual(book, .joshua)
    }
    
    
    func testBookNext() throws {
        let gen = Book.genesis
        XCTAssertEqual(gen.next, .exodus)
        let psa = Book.psalms
        XCTAssertEqual(psa.next, .proverbs)
        let rev = Book.revelation
        XCTAssertNil(rev.next)
    }
    
    func testBookId() throws {
        let gen = Book.genesis
        XCTAssertEqual(gen.id, Book.genesis)
    }
    
}
