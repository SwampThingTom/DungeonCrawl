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
        let damageDice = MockDie(nextRoll: 10)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDice: damageDice, maxHitPoints: 10)
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
        let damageDice = MockDie(nextRoll: 10)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDice: damageDice, maxHitPoints: 10)
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
        
        let armor = ItemComponent(item: mockArmor(bonus: 2))
        inventory.items.append(armor)
        inventory.equip(itemComponent: armor)
        
        let damageDice = MockDie(nextRoll: 10)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDice: damageDice, maxHitPoints: 10)
        entity?.add(component: sut)
        
        // Act
        let armorClass = sut.armorClass
        
        // Assert
        XCTAssertEqual(armorClass, 12)
    }
    
    func testWeaponDamage_noItems() throws {
        // Arrange
        let entity = entityManager?.createEntity()
        let damageDice = MockDie(nextRoll: 3)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDice: damageDice, maxHitPoints: 10)
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
        let damageDice = MockDie(nextRoll: 3)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDice: damageDice, maxHitPoints: 10)
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
        
        let weapon = ItemComponent(item: mockWeapon(damageDice: MockDie(nextRoll: 10)))
        inventory.items.append(weapon)
        inventory.equip(itemComponent: weapon)
        
        let damageDice = MockDie(nextRoll: 3)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDice: damageDice, maxHitPoints: 10)
        entity?.add(component: sut)
        
        // Act
        let damage = sut.weaponDamage
        
        // Assert
        XCTAssertEqual(damage, 10)
    }
    
    func testHeal() throws {
        // Arrange
        let entity = entityManager?.createEntity()
        let damageDice = MockDie(nextRoll: 10)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDice: damageDice, maxHitPoints: 10)
        entity?.add(component: sut)
        sut.hitPoints = 1
        
        // Act
        sut.heal(damage: 3)
        
        // Assert
        XCTAssertEqual(sut.hitPoints, 4)
    }
    
    func testHeal_max() throws {
        // Arrange
        let entity = entityManager?.createEntity()
        let damageDice = MockDie(nextRoll: 10)
        let sut = CombatComponent(attackBonus: 10, armorClass: 10, damageDice: damageDice, maxHitPoints: 10)
        entity?.add(component: sut)
        sut.hitPoints = 1
        
        // Act
        sut.heal(damage: 13)
        
        // Assert
        XCTAssertEqual(sut.hitPoints, 10)
    }
}

func mockArmor(bonus: Int, name: String = "Mock Armor") -> Item {
    return ItemBuilder(name: name)
        .with(equipmentSlot: .armor)
        .with(armorBonus: bonus)
        .build()
}

func mockWeapon(damageDice: DieRolling, name: String = "Mock Weapon") -> Item {
    return ItemBuilder(name: name)
        .with(equipmentSlot: .weapon)
        .with(damageDice: damageDice)
        .build()
}
