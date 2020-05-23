//
//  CombatComponentTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/22/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class CombatComponentTests: XCTestCase {
    
    var entityManager: EntityManager?
    
    override func setUp() {
        entityManager = EntityManager()
    }
    
    override func tearDown() {
        entityManager = nil
    }

    func testArmorClass_noItems() throws {
        // Arrange
        let entity = entityManager?.createEntity()
        let damageDie = MockDie(nextRoll: 10)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDie: damageDie, maxHitPoints: 10)
        entity?.add(component: sut)
        
        // Act
        let armorClass = sut.armorClass
        
        // Assert
        XCTAssertEqual(armorClass, 10)
    }
    
    func testArmorClass_noEquippedArmor() throws {
        // Arrange
        let entity = entityManager?.createEntity()
        let items = ItemsComponent()
        entity?.add(component: items)
        let damageDie = MockDie(nextRoll: 10)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDie: damageDie, maxHitPoints: 10)
        entity?.add(component: sut)
        
        // Act
        let armorClass = sut.armorClass
        
        // Assert
        XCTAssertEqual(armorClass, 10)
    }
    
    func testArmorClass_equippedArmor() throws {
        // Arrange
        let entity = entityManager?.createEntity()
        
        let items = ItemsComponent()
        entity?.add(component: items)
        
        let armor = mockArmor(bonus: 2)
        items.equipped[.armor] = armor
        
        let damageDie = MockDie(nextRoll: 10)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDie: damageDie, maxHitPoints: 10)
        entity?.add(component: sut)
        
        // Act
        let armorClass = sut.armorClass
        
        // Assert
        XCTAssertEqual(armorClass, 12)
    }
    
    func mockArmor(bonus: Int) -> Item {
        return ItemBuilder(name: "Mock Armor")
            .with(armor: ArmorModel(armorBonus: bonus))
            .build()
    }
}
