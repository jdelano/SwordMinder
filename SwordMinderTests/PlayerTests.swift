//
//  PlayerTests.swift
//  SwordMinderTests
//
//  Created by John Delano on 10/9/22.
//

import XCTest
@testable import SwordMinder

final class PlayerTests: XCTestCase {
    private var player: Player = Player()
    
    override func setUpWithError() throws {
        player = Player(withArmor: [
            Player.Armor(piece: .helmet),
            Player.Armor(piece: .breastplate),
            Player.Armor(piece: .belt),
            Player.Armor(piece: .shoes),
        ], armorMaterial: .linen, gems: 5000, passages: [
            Passage(from: Reference()),
            Passage(from: Reference(book: .john, chapter: 3, verse: 16))
        ])
    }
        
    func testInitNoParams() throws {
        XCTAssert(player.armor.count == 4)
        XCTAssert(player.armorMaterial == .linen)
        let helmet = player.armor.first(where: { $0.piece == .helmet })
        XCTAssert(helmet?.level == 1)
        let breastplate = player.armor.first(where: { $0.piece == .breastplate })
        XCTAssert(breastplate?.level == 1)
        let belt = player.armor.first(where: { $0.piece == .belt })
        XCTAssert(belt?.level == 1)
        let shoes = player.armor.first(where: { $0.piece == .shoes })
        XCTAssert(shoes?.level == 1)
    }
    
    func testInitWithArmor() throws {
        player = Player(withArmor: [
            Player.Armor(piece: .helmet),
            Player.Armor(piece: .helmet),
            Player.Armor(piece: .breastplate),
            Player.Armor(piece: .breastplate),
            Player.Armor(piece: .belt),
            Player.Armor(piece: .belt),
            Player.Armor(piece: .shoes),
            Player.Armor(piece: .shoes),
        ])
        // Should only accept the first of each armor piece
        XCTAssert(player.armor.count == 4)
        let helmet = player.armor.first(where: { $0.piece == .helmet })
        XCTAssert(helmet?.level == 1)
        let breastplate = player.armor.first(where: { $0.piece == .breastplate })
        XCTAssert(breastplate?.level == 1)
        let belt = player.armor.first(where: { $0.piece == .belt })
        XCTAssert(belt?.level == 1)
        let shoes = player.armor.first(where: { $0.piece == .shoes })
        XCTAssert(shoes?.level == 1)
    }
    
    func testInitWithArmorButEmptyArray() throws {
        player = Player(withArmor: [])
        XCTAssert(player.armor.count == 4)
        let helmet = player.armor.first(where: { $0.piece == .helmet })
        XCTAssert(helmet?.level == 1)
        let breastplate = player.armor.first(where: { $0.piece == .breastplate })
        XCTAssert(breastplate?.level == 1)
        let belt = player.armor.first(where: { $0.piece == .belt })
        XCTAssert(belt?.level == 1)
        let shoes = player.armor.first(where: { $0.piece == .shoes })
        XCTAssert(shoes?.level == 1)
    }
    
    func testInitWithArmorAndGems() throws {
        player = Player(withArmor: [
            Player.Armor(piece: .helmet),
            Player.Armor(piece: .helmet),
            Player.Armor(piece: .breastplate),
            Player.Armor(piece: .breastplate),
            Player.Armor(piece: .belt),
            Player.Armor(piece: .belt),
            Player.Armor(piece: .shoes),
            Player.Armor(piece: .shoes),
        ], gems: 50)
        // Should only accept the first of each armor piece
        XCTAssert(player.armor.count == 4)
        let helmet = player.armor.first(where: { $0.piece == .helmet })
        XCTAssert(helmet?.level == 1)
        let breastplate = player.armor.first(where: { $0.piece == .breastplate })
        XCTAssert(breastplate?.level == 1)
        let belt = player.armor.first(where: { $0.piece == .belt })
        XCTAssert(belt?.level == 1)
        let shoes = player.armor.first(where: { $0.piece == .shoes })
        XCTAssert(shoes?.level == 1)
        XCTAssert(player.gems == 50)
    }

    func testInitWithArmorGemsAndPassages() throws {
        player = Player(withArmor: [
            Player.Armor(piece: .helmet),
            Player.Armor(piece: .helmet),
            Player.Armor(piece: .breastplate),
            Player.Armor(piece: .breastplate),
            Player.Armor(piece: .belt),
            Player.Armor(piece: .belt),
            Player.Armor(piece: .shoes),
            Player.Armor(piece: .shoes),
        ], gems: 50, passages: [
            Passage(from: Reference()),
            Passage(from: Reference(book: .john, chapter: 3, verse: 16))
            ])
        // Should only accept the first of each armor piece
        XCTAssert(player.armor.count == 4)
        let helmet = player.armor.first(where: { $0.piece == .helmet })
        XCTAssert(helmet?.level == 1)
        let breastplate = player.armor.first(where: { $0.piece == .breastplate })
        XCTAssert(breastplate?.level == 1)
        let belt = player.armor.first(where: { $0.piece == .belt })
        XCTAssert(belt?.level == 1)
        let shoes = player.armor.first(where: { $0.piece == .shoes })
        XCTAssert(shoes?.level == 1)
        XCTAssert(player.gems == 50)
        XCTAssert(player.passages.count == 2)
        XCTAssert(player.passages.first!.referenceFormatted == "Genesis 1:1 (ESV)")
    }

    func testInitWithDecoder() throws {
        var player = Player()
        player.addPassage(Passage())
        let json = try! player.json()
        print(String(data: json, encoding: .utf8)!)
        let player2 = try! JSONDecoder().decode(Player.self, from: json)
        XCTAssert(player2.passages.count == 1)
    }
    
//    func testArmorLevelForPiece() throws {
//        player.levelUp(piece: .helmet)
//        XCTAssert(player.armorLevel(for: .helmet) == 2)
//        player.levelUp(piece: .breastplate)
//        XCTAssert(player.armorLevel(for: .breastplate) == 2)
//        player.levelUp(piece: .belt)
//        XCTAssert(player.armorLevel(for: .belt) == 2)
//        player.levelUp(piece: .shoes)
//        XCTAssert(player.armorLevel(for: .shoes) == 2)
//    }
    
    func testPlayerLevel() throws {
        XCTAssert(player.level == 1)
        for _ in 0..<(Player.PlayerConstants.maxLevel - 1) {
            player.levelUp(piece: .helmet)
        }
        XCTAssert(player.level == 10)
        for _ in 0..<(Player.PlayerConstants.maxLevel - 1) {
            player.levelUp(piece: .breastplate)
        }
        XCTAssert(player.level == 20)
        for _ in 0..<(Player.PlayerConstants.maxLevel - 1) {
            player.levelUp(piece: .belt)
        }
        XCTAssert(player.level == 30)
        for _ in 0..<(Player.PlayerConstants.maxLevel - 1) {
            player.levelUp(piece: .shoes)
        }
        XCTAssert(player.level == 40)

    }
    
    func testEligibleOnInit() throws {
        XCTAssert(player.eligible == true)
    }
    
    func testRewardInRange() throws {
        player = Player()
        player.reward(gems: 1)
        XCTAssert(player.gems == 1)
        player.reward(gems: 2)
        XCTAssert(player.gems == 3)
        player.reward(gems: 3)
        XCTAssert(player.gems == 6)
        player.reward(gems: 4)
        XCTAssert(player.gems == 10)
        player.reward(gems: 5)
        XCTAssert(player.gems == 15)
    }
    
    func testRewardOutOfRange() throws {
        player = Player()
        XCTAssert(player.gems == 0)
        player.reward(gems: 0)
        XCTAssert(player.gems == 0)
        player.reward(gems: -1)
        XCTAssert(player.gems == 0)
        player.reward(gems: 6)
        XCTAssert(player.gems == 0)
    }
    
    func testCanLevelUp() throws {
        for _ in 0..<(Player.PlayerConstants.maxLevel - 2) {
            player.levelUp(piece: .helmet)
        } // Gets player's helmet to 1 level below max (armor always starts at level 1)
        XCTAssert(player.canLevelUp(armorPiece: .helmet)) // should still be able to upgrade it
        player.levelUp(piece: .helmet) // upgrades to max level
        XCTAssert(!player.canLevelUp(armorPiece: .helmet)) // should not be able to upgrade it now
    }
    
    func testEligibleLessThan5In24Hours() throws {
        for _ in 0..<5 {
            player.reward(gems: 1)
        }
        XCTAssert(player.eligible == false)
    }
    
    func testSpendGem() {
        
    }
    
}
