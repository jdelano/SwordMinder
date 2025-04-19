//
//  VerseCacheUnitTests.swift
//  SwordMinder
//
//  Created by John Delano on 4/19/25.
//

import XCTest
@testable import SwordMinder

final class VerseCacheUnitTests: XCTestCase {
    
    func testVerseTextLoadsFromFile() async throws {
        let bundle = Bundle(for: type(of: self))
        let fileURL = bundle.url(forResource: "John-3-16-kjv", withExtension: "json")!
        let cache = VerseCache(baseURL: fileURL)
        
        let key = VerseRequest(reference: Reference(book: .john, chapter: 3, verse: 16), translation: .kjv)
        let text = try await cache.getText(for: key)
        XCTAssertEqual(text, "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.")
    }
    
    func testVerseTextCachesAfterFirstLoad() async throws {
        let bundle = Bundle(for: type(of: self))
        let fileURL = bundle.url(forResource: "John-3-16-kjv", withExtension: "json")!
        let cache = VerseCache(baseURL: fileURL)
        
        let key = VerseRequest(reference: Reference(book: .john, chapter: 3, verse: 16), translation: .kjv)
        _ = try await cache.getText(for: key) // First load
        let text = try await cache.getText(for: key) // Should hit cache
        XCTAssertEqual(text, "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.")
    }
    
    func testMissingFileThrows() async {
        let badURL = URL(fileURLWithPath: "/nonexistent/path/to/file.json")
        let cache = VerseCache(baseURL: badURL)
        let key = VerseRequest(reference: Reference(book: .john, chapter: 3, verse: 16), translation: .kjv)
        await XCTAssertThrowsErrorAsync(_ = try await cache.getText(for: key))
    }
}

extension XCTestCase {
    func XCTAssertThrowsErrorAsync(_ expression: @autoclosure @escaping () async throws -> Void,
                                   _ message: @autoclosure () -> String = "",
                                   file: StaticString = #file,
                                   line: UInt = #line) async {
        do {
            try await expression()
            XCTFail("Expected error, but no error was thrown", file: file, line: line)
        } catch {
            // Test passes
        }
    }
}
