//
//  BookTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/2/22.
//

import XCTest
@testable import SwordMinder

final class BookTests: XCTestCase {

    let bibleJSON =
    [
        [
            "abbr": "1John",
            "book": "1 John",
            "chapters": [
                [
                    "chapter": 1,
                    "verses": 10
                ],
                [
                    "chapter": 2,
                    "verses": 29
                ],
                [
                    "chapter": 3,
                    "verses": 24
                ],
                [
                    "chapter": 4,
                    "verses": 21
                ],
                [
                    "chapter": 5,
                    "verses": 21
                ]
            ]
        ],
        [
            "abbr": "2John",
            "book": "2 John",
            "chapters": [
                [
                    "chapter": 1,
                    "verses": 13
                ]
            ]
        ],
        [
            "abbr": "3John",
            "book": "3 John",
            "chapters": [
                [
                    "chapter": 1,
                    "verses": 14
                ]
            ]
        ],
        [
            "abbr": "Jude",
            "book": "Jude",
            "chapters": [
                [
                    "chapter": 1,
                    "verses": 25
                ]
            ]
        ],
        [
            "book": "Revelation"
        ],
        [
            "book" : "XYZBook"
        ]
    ]
    
    // MARK: - Book Tests
    
    func testBookNames() throws {
        let bookNames = Book.names
        XCTAssert(bookNames.count == 66)
        print(bookNames)
        XCTAssert(bookNames[0] == "Genesis")
        XCTAssert(bookNames[1] == "Exodus")
        XCTAssert(bookNames[38] == "Malachi")
        XCTAssert(bookNames[39] == "Matthew")
        XCTAssert(bookNames[65] == "Revelation")
    }

    func testBookInit() throws {
        var book = Book(named: "Genesis")!
        XCTAssert(book.name == "Genesis")
        XCTAssert(book.chapters.isEmpty)
        XCTAssert(book.abbr == "Gen")
        
        book = Book(named: "Joshua")!
        XCTAssert(book.name == "Joshua")
        XCTAssert(book.abbr == "Josh")
        XCTAssert(book.chapters.isEmpty)
                
        // Book struct does not attempt to validate appropriate book name
        let xyzBook = Book(named: "XYZBook")
        XCTAssert(xyzBook == nil)
    }
    

    func testBookInitFromDecoder() throws {
        let data = try! JSONSerialization.data(withJSONObject: bibleJSON, options: [])
        let books = try! JSONDecoder().decode([Book].self, from: data)
        XCTAssert(books.count == 6)
    }
    
    func testBookEncode() throws {
        let book = Book(named: "Genesis")
        let data = try JSONEncoder().encode(book)
        let book2 = try JSONDecoder().decode(Book.self, from: data)
        XCTAssert(book2.name == "Genesis")
    }
    
    func testBookLessThan() throws {
        let book1 = Book(named: "Genesis")!
        let book2 = Book(named: "Exodus")!
        XCTAssert(book1 < book2)
        XCTAssert(!(book2 < book1))
        let data = try! JSONSerialization.data(withJSONObject: bibleJSON, options: [])
        let books = try! JSONDecoder().decode([Book].self, from: data)
        XCTAssert(!(books.last! < book1))
    }
    
    func testBookGreaterThan() throws {
        let book1 = Book(named: "Genesis")!
        let book2 = Book(named: "Exodus")!
        XCTAssert(book2 > book1)
        XCTAssert(!(book1 > book2))
        let data = try! JSONSerialization.data(withJSONObject: bibleJSON, options: [])
        let books = try! JSONDecoder().decode([Book].self, from: data)
        XCTAssert(!(books.last! > book1))
    }
    
    func testBookEqualTo() throws {
        let book1 = Book(named: "Genesis")!
        let book2 = Book(named: "Genesis")!
        XCTAssert(book1 == book2)
    }

    func testBookChangeName() throws {
        var book = Book()!
        book.name = "Joshua"
        XCTAssert(book.name == "Joshua")
        XCTAssert(book.abbr == "Josh")
    }
}
