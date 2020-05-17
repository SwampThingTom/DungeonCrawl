//
//  CombatTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class CombatTests: XCTestCase {

    func testAttack_hit() throws {
        // Arrange
        let attacker = MockCombatant(attackBonus: 1, armorClass: 11)
        let defender = MockCombatant(attackBonus: 1, armorClass: 11)
        let d20 = MockD20(nextRoll: 10)
        let sut = CombatSystem(d20: d20)
        
        // Act
        let damage = sut.attack(attacker: attacker, defender: defender)
        
        // Assert
        XCTAssertEqual(damage, 1)
    }
    
    func testAttack_miss() throws {
        // Arrange
        let attacker = MockCombatant(attackBonus: 1, armorClass: 11)
        let defender = MockCombatant(attackBonus: 1, armorClass: 12)
        let d20 = MockD20(nextRoll: 10)
        let sut = CombatSystem(d20: d20)

        // Act
        let damage = sut.attack(attacker: attacker, defender: defender)
        
        // Assert
        XCTAssertNil(damage)
    }
    
    func testAttack_naturalHit() throws {
        // Arrange
        let attacker = MockCombatant(attackBonus: 1, armorClass: 10)
        let defender = MockCombatant(attackBonus: 1, armorClass: 22)
        let d20 = MockD20(nextRoll: 20)
        let sut = CombatSystem(d20: d20)

        // Act
        let damage = sut.attack(attacker: attacker, defender: defender)
        
        // Assert
        XCTAssertEqual(damage, 1)
    }
    
    func testAttack_naturalMiss() throws {
        // Arrange
        let attacker = MockCombatant(attackBonus: 1, armorClass: 11)
        let defender = MockCombatant(attackBonus: 1, armorClass: 1)
        let d20 = MockD20(nextRoll: 1)
        let sut = CombatSystem(d20: d20)
        
        // Act
        let damage = sut.attack(attacker: attacker, defender: defender)
        
        // Assert
        XCTAssertNil(damage)
    }
}

struct MockCombatant: Combatant {
    var attackBonus: Int
    var armorClass: Int
    var hitPoints: Int = 10
    var weaponDamage: Int = 1
}

struct MockD20: D20Providing {
    
    var nextRoll: Int
    
    func roll() -> Int {
        return nextRoll
    }
}
