//
//  LeaderboardTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 10/21/22.
//

import XCTest
@testable import SwordMinder

final class LeaderboardTests: XCTestCase {

    private var leaderboard: Leaderboard = Leaderboard()
    
    override func setUpWithError() throws {
        leaderboard = Leaderboard()
    }

    func testInit() throws {
        XCTAssert(leaderboard.entries.count == 0)
    }

    func testInitWithEntries() throws {
        leaderboard = Leaderboard(entries: [
            SwordMinder.Entry(app:"Bible Trivia", score: 500),
            SwordMinder.Entry(app:"Bible Tetris", score: 500),
            SwordMinder.Entry(app:"Speak'n'Say", score: 500),
            SwordMinder.Entry(app:"Talk it Out", score: 500),
            SwordMinder.Entry(app:"Block Book", score: 500)
        ])
        XCTAssert(leaderboard.entries.count == 5)
    }
    
    func testAddEntry() throws {
        leaderboard.add(app: "Testing", score: 500)
        XCTAssert(leaderboard.entries.count == 1)
        XCTAssert(leaderboard.entries.first!.app == "Testing")
        XCTAssert(leaderboard.entries.first!.score == 500)
    }
    
    func testUpdateEntry() throws {
        leaderboard.add(app: "Testing", score: 500)
        leaderboard.update(index: 0, score: 1000)
        XCTAssert(leaderboard.entries.count == 1)
        XCTAssert(leaderboard.entries.first!.app == "Testing")
        XCTAssert(leaderboard.entries.first!.score == 1000)
    }

}
