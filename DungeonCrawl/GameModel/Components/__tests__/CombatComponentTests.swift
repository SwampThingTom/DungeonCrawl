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
        let inventory = InventoryComponent()
        entity?.add(component: inventory)
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
        
        let inventory = InventoryComponent()
        entity?.add(component: inventory)
        
        let armor = mockArmor(bonus: 2)
        inventory.equip(item: armor)
        
        let damageDie = MockDie(nextRoll: 10)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDie: damageDie, maxHitPoints: 10)
        entity?.add(component: sut)
        
        // Act
        let armorClass = sut.armorClass
        
        // Assert
        XCTAssertEqual(armorClass, 12)
    }
    
    func testWeaponDamage_noItems() throws {
        // Arrange
        let entity = entityManager?.createEntity()
        let damageDie = MockDie(nextRoll: 3)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDie: damageDie, maxHitPoints: 10)
        entity?.add(component: sut)
        
        // Act
        let damage = sut.weaponDamage
        
        // Assert
        XCTAssertEqual(damage, 3)
    }
    
    func testWeaponDamage_noEquippedWeapon() throws {
        // Arrange
        let entity = entityManager?.createEntity()
        let inventory = InventoryComponent()
        entity?.add(component: inventory)
        let damageDie = MockDie(nextRoll: 3)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDie: damageDie, maxHitPoints: 10)
        entity?.add(component: sut)
        
        // Act
        let damage = sut.weaponDamage
        
        // Assert
        XCTAssertEqual(damage, 3)
    }
    
    func testWeaponDamage_equippedWeapon() throws {
        // Arrange
        let entity = entityManager?.createEntity()
        
        let inventory = InventoryComponent()
        entity?.add(component: inventory)
        
        let weapon = mockWeapon(damageDie: MockDie(nextRoll: 10))
        inventory.equip(item: weapon)
        
        let damageDie = MockDie(nextRoll: 3)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDie: damageDie, maxHitPoints: 10)
        entity?.add(component: sut)
        
        // Act
        let damage = sut.weaponDamage
        
        // Assert
        XCTAssertEqual(damage, 10)
    }
}

func mockArmor(bonus: Int, name: String = "MockArmor") -> Item {
    return ItemBuilder(name: name)
        .with(equipmentSlot: .armor)
        .with(armor: ArmorModel(armorBonus: bonus))
        .build()
}

func mockWeapon(damageDie: DieRolling, name: String = "Mock Weapon") -> Item {
    return ItemBuilder(name: name)
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: damageDie))
        .build()
}
