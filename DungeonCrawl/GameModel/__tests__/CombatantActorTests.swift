//
//  CombatantActorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class CombatantActorTests: XCTestCase {

    func testDamage() throws {
        // Arrange
        let sut = CombatantActor(name: "Combatant", displayName: "Combatant", cell: GridCell(x: 0, y: 0))
        
        // Act
        let damage = sut.damage()
        
        // Assert
        XCTAssertEqual(damage, 1)
    }
    
    func testTakeDamage() throws {
        // Arrange
        let sut = CombatantActor(name: "Combatant", displayName: "Combatant", cell: GridCell(x: 0, y: 0))
        sut.hitPoints = 10
        
        // Act
        sut.takeDamage(3)
        
        // Assert
        XCTAssertEqual(sut.hitPoints, 7)
    }
    
    func testAttack() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        let target = MockCombatant(attackBonus: 1, armorClass: 1)
        let sut = CombatantActor(name: "Combatant", displayName: "Combatant", cell: GridCell(x: 0, y: 0))
        sut.combat = mockCombat
        
        // Act
        let damage = sut.attack(target)
        
        // Assert
        XCTAssertEqual(damage, 3)
    }
}

class MockCombat: CombatProviding {
    
    var d20: D20Providing = D20()
    
    var mockAttackDamage: Int?
    
    func attack(attacker: Combatant, defender: Combatant) -> Int? {
        return mockAttackDamage
    }
}
