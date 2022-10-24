//
//  ArmorTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 10/13/22.
//

import XCTest
@testable import SwordMinder

final class ArmorTests: XCTestCase {

    
    func testProperties() throws {
        let armor = Player.Armor(piece: .helmet)
        XCTAssert(armor.piece == .helmet)
        XCTAssert(armor.level == 1)
        XCTAssert(armor.charged == false)
    }
    
    func testLevelUp() throws {
        let armor = Player.Armor(piece: .helmet)
        var player = Player(withArmor: [armor], gems: 5000)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 3)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 4)
        for _ in 0..<3 {
            player.levelUp(piece: .helmet)
        }
        XCTAssert(player.armor.first!.costToLevelUp() == 5)
        for _ in 0..<3 {
            player.levelUp(piece: .helmet)
        }
        XCTAssert(player.armor.first!.costToLevelUp() == 6)
        for _ in 0..<4 {
            player.levelUp(piece: .helmet)
        }
        XCTAssert(player.armor.first!.costToLevelUp() == 7)
        for _ in 0..<4 {
            player.levelUp(piece: .helmet)
        }
        XCTAssert(player.armor.first!.costToLevelUp() == 8)
        for _ in 0..<2 {
            player.levelUp(piece: .helmet)
        }
        XCTAssert(player.armor.first!.costToLevelUp() == 9)
        for _ in 0..<2 {
            player.levelUp(piece: .helmet)
        }
        XCTAssert(player.armor.first!.costToLevelUp() == 10)
        for _ in 0..<2 {
            player.levelUp(piece: .helmet)
        }
        XCTAssert(player.armor.first!.costToLevelUp() == 11)
        for _ in 0..<2 {
            player.levelUp(piece: .helmet)
        }
        XCTAssert(player.armor.first!.costToLevelUp() == 12)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 13)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 14)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 15)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 16)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 18)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 19)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 21)
        player.levelUp(piece: .helmet)
        XCTAssert(player.armor.first!.costToLevelUp() == 23)
    }


}
