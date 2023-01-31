//
//  WordSearchTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 12/3/22.
//

import XCTest
@testable import SwordMinder

final class WordSearchTests: XCTestCase {

    func testWordSearchMakeGrid() throws {
        let wordSearch = WordSearch()
        wordSearch.makeGrid()
        print(wordSearch.grid)
    }

    
    func testWordSearchMakeGridWithVerse() async throws {
//        let verseText = bible.text(for: Passage())
//        let wordSearch = WordSearch()
//        wordSearch.words = verseText.split(separator: " ").map { Word(text: String($0)) }
//        wordSearch.makeGrid()
//        print(wordSearch.grid)

    }
    
    func testWordSearchMakeGridWordsUsed() async throws {
//        let wordSearch = WordSearch()
//
//        wordSearch.words = bible.words(for: Passage()).map { Word(text: $0) }
//        wordSearch.makeGrid()
//        print(wordSearch.wordsUsed)

    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
