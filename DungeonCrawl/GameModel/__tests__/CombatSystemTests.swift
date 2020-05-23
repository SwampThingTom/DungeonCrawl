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

    var entityManager: EntityManager?
    var entityFactory: EntityFactory?
    
    override func setUp() {
        entityManager = EntityManager()
        entityFactory = EntityFactory(entityManager: entityManager!)
    }
    
    override func tearDown() {
        entityManager = nil
        entityFactory = nil
    }

    func testAttack_hit() throws {
        // Arrange
        let attackerCombat = mockCombatComponent(attackBonus: 1, armorClass: 11)
        let defenderCombat = mockCombatComponent(attackBonus: 1, armorClass: 11)
        
        let d20 = MockDie(nextRoll: 10)
        let sut = CombatSystem(entityManager: entityManager!, d20: d20)
        
        // Act
        let damage = sut.attack(attacker: attackerCombat, defender: defenderCombat)
        
        // Assert
        XCTAssertEqual(damage, 1)
    }
    
    func testAttack_miss() throws {
        // Arrange
        let attackerCombat = mockCombatComponent(attackBonus: 1, armorClass: 11)
        let defenderCombat = mockCombatComponent(attackBonus: 1, armorClass: 12)

        let d20 = MockDie(nextRoll: 10)
        let sut = CombatSystem(entityManager: entityManager!, d20: d20)

        // Act
        let damage = sut.attack(attacker: attackerCombat, defender: defenderCombat)
        
        // Assert
        XCTAssertNil(damage)
    }
    
    func testAttack_naturalHit() throws {
        // Arrange
        let attackerCombat = mockCombatComponent(attackBonus: 1, armorClass: 10)
        let defenderCombat = mockCombatComponent(attackBonus: 1, armorClass: 22)

        let d20 = MockDie(nextRoll: 20)
        let sut = CombatSystem(entityManager: entityManager!, d20: d20)

        // Act
        let damage = sut.attack(attacker: attackerCombat, defender: defenderCombat)
        
        // Assert
        XCTAssertEqual(damage, 1)
    }
    
    func testAttack_naturalMiss() throws {
        // Arrange
        let attackerCombat = mockCombatComponent(attackBonus: 1, armorClass: 11)
        let defenderCombat = mockCombatComponent(attackBonus: 1, armorClass: 1)

        let d20 = MockDie(nextRoll: 1)
        let sut = CombatSystem(entityManager: entityManager!, d20: d20)
        
        // Act
        let damage = sut.attack(attacker: attackerCombat, defender: defenderCombat)
        
        // Assert
        XCTAssertNil(damage)
    }
    
    func mockCombatComponent(attackBonus: Int, armorClass: Int) -> CombatComponent {
        let damageDie = MockDie(nextRoll: 1)
        return CombatComponent(attackBonus: attackBonus, armorClass: armorClass, damageDie: damageDie, maxHitPoints: 10)
    }
    
    func entityWithCombatComponent(combatComponent: CombatComponent) -> Entity {
        let entity = entityManager!.createEntity()
        entityManager!.add(component: combatComponent, to: entity)
        return entity
    }
}

struct MockDie: DieRolling {
    
    var nextRoll: Int
    
    func roll() -> Int {
        return nextRoll
    }
}
