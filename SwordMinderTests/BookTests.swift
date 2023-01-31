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
        XCTAssert(book == .genesis)
        
        book = Book.joshua
        XCTAssert(book == Book.joshua)
                
        let xyzBook = Book(rawValue: "XYZBook")
        XCTAssert(xyzBook == nil)
        
        let firstJohn = Book.firstJohn
        XCTAssert(firstJohn == .firstJohn)
    }
    

    func testBookLessThan() throws {
        let book1 = Book.genesis
        let book2 = Book.exodus
        XCTAssert(book1 < book2)
        XCTAssert(!(book2 < book1))
    }
    
    func testBookGreaterThan() throws {
        let book1 = Book.genesis
        let book2 = Book.exodus
        XCTAssert(book2 > book1)
        XCTAssert(!(book1 > book2))
    }
    
    func testBookEqualTo() throws {
        let book1 = Book.genesis
        let book2 = Book.genesis
        XCTAssert(book1 == book2)
    }

    func testBookChangeName() throws {
        var book = Book.genesis
        book = .joshua
        XCTAssert(book == .joshua)
    }
    
    
    func testBookNext() throws {
        let gen = Book.genesis
        XCTAssert(gen.next! == .exodus)
        let psa = Book.psalms
        XCTAssert(psa.next! == .proverbs)
        let rev = Book.revelation
        XCTAssert(rev.next == nil)
    }
    
    func testBookId() throws {
        let gen = Book.genesis
        XCTAssert(gen.id == Book.genesis)
    }

}
