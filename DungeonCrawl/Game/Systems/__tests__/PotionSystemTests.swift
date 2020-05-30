//
//  PotionSystemTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/29/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class PotionSystemTests: XCTestCase {

    func testUse_heal() throws {
        // Arrange
        let entityManager = EntityManager()
        let combatComponent = CombatComponent(attackBonus: 0, armorClass: 0, damageDice: D4(), maxHitPoints: 10)
        combatComponent.hitPoints = 5
        let healTarget = mockHealTarget(entityManager: entityManager, combatComponent: combatComponent)
        let sut = PotionSystem(entityManager: entityManager)
        
        // Act
        sut.use(potion: .heal, on: healTarget)
        
        // Assert
        XCTAssertGreaterThan(combatComponent.hitPoints, 5)
    }
    
    func mockHealTarget(entityManager: EntityManager, combatComponent: CombatComponent) -> Entity {
        let healTarget = entityManager.createEntity()
        healTarget.add(component: combatComponent)
        return healTarget
    }
}
