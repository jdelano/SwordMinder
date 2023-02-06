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
    
    
    func testTilesInAlmostDiagonalLine() throws {
        let wordSearch = WordSearch()
        wordSearch.makeGrid()
        print(wordSearch.grid)
        let tilesinLine = wordSearch.tilesInLine(from: (row:0, col:0), to: (row: 3, col: 2))
        XCTAssert(tilesinLine[0].id == wordSearch.grid[0][0].id)
        XCTAssert(tilesinLine[1].id == wordSearch.grid[1][1].id)
        XCTAssert(tilesinLine[2].id == wordSearch.grid[2][2].id)
    }

    func testTilesInVerticalLine() throws {
        let wordSearch = WordSearch()
        wordSearch.makeGrid()
        print(wordSearch.grid)
        let tilesinLine = wordSearch.tilesInLine(from: (row:0, col:0), to: (row: 7, col: 0))
        XCTAssert(tilesinLine[0].id == wordSearch.grid[0][0].id)
        XCTAssert(tilesinLine[1].id == wordSearch.grid[1][0].id)
        XCTAssert(tilesinLine[2].id == wordSearch.grid[2][0].id)
        XCTAssert(tilesinLine[3].id == wordSearch.grid[3][0].id)
        XCTAssert(tilesinLine[4].id == wordSearch.grid[4][0].id)
        XCTAssert(tilesinLine[5].id == wordSearch.grid[5][0].id)
        XCTAssert(tilesinLine[6].id == wordSearch.grid[6][0].id)
        XCTAssert(tilesinLine[7].id == wordSearch.grid[7][0].id)
    }

    func testTilesInHorizontalLine() throws {
        let wordSearch = WordSearch()
        wordSearch.makeGrid()
        print(wordSearch.grid)
        let tilesinLine = wordSearch.tilesInLine(from: (row:0, col:0), to: (row: 0, col: 7))
        XCTAssert(tilesinLine[0].id == wordSearch.grid[0][0].id)
        XCTAssert(tilesinLine[1].id == wordSearch.grid[0][1].id)
        XCTAssert(tilesinLine[2].id == wordSearch.grid[0][2].id)
        XCTAssert(tilesinLine[3].id == wordSearch.grid[0][3].id)
        XCTAssert(tilesinLine[4].id == wordSearch.grid[0][4].id)
        XCTAssert(tilesinLine[5].id == wordSearch.grid[0][5].id)
        XCTAssert(tilesinLine[6].id == wordSearch.grid[0][6].id)
        XCTAssert(tilesinLine[7].id == wordSearch.grid[0][7].id)
    }

}
