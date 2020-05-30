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
        
        let potion = potionItem(entityManager: entityManager, potionType: .heal)
        
        let combatComponent = CombatComponent(attackBonus: 0, armorClass: 0, damageDice: D4(), maxHitPoints: 10)
        combatComponent.hitPoints = 5
        let healTarget = mockHealTarget(entityManager: entityManager, combatComponent: combatComponent)
        
        let sut = PotionSystem(entityManager: entityManager)
        
        // Act
        sut.use(potionItem: potion, on: healTarget)
        
        // Assert
        XCTAssertGreaterThan(combatComponent.hitPoints, 5)
    }
    
    func testUse_heal_inventory() throws {
        // Arrange
        let entityManager = EntityManager()
        
        let potion = potionItem(entityManager: entityManager, potionType: .heal)
        let inventory = self.inventory(entityManager: entityManager)
        inventory.items.append(potion)
        
        let combatComponent = CombatComponent(attackBonus: 0, armorClass: 0, damageDice: D4(), maxHitPoints: 10)
        combatComponent.hitPoints = 5
        let healTarget = mockHealTarget(entityManager: entityManager, combatComponent: combatComponent)
        
        let sut = PotionSystem(entityManager: entityManager)
        
        // Act
        sut.use(potionItem: potion, on: healTarget, from: inventory)
        
        // Assert
        XCTAssertGreaterThan(combatComponent.hitPoints, 5)
        XCTAssertFalse(inventory.items.contains(potion))
    }
    
    func testUse_armorBonus() throws {
        // Arrange
        let entityManager = EntityManager()
        
        let inventory = self.inventory(entityManager: entityManager)
        let armor = ItemComponent(item: mockArmor(bonus: 2))
        inventory.add(item: armor)
        inventory.equip(itemComponent: armor)
        
        let potion = potionItem(entityManager: entityManager, potionType: .armorBonus)
        inventory.items.append(potion)
        
        let sut = PotionSystem(entityManager: entityManager)

        // Act
        sut.use(potionItem: potion, on: inventory.entity!)
        
        // Assert
        XCTAssertEqual(armor.item.armorBonus, 3)
    }
    
    func testUse_armorBonus_unequipped() throws {
        // Arrange
        let entityManager = EntityManager()
        
        let inventory = self.inventory(entityManager: entityManager)
        let armor = ItemComponent(item: mockArmor(bonus: 2))
        inventory.add(item: armor)
        
        let potion = potionItem(entityManager: entityManager, potionType: .armorBonus)
        inventory.items.append(potion)
        
        let sut = PotionSystem(entityManager: entityManager)

        // Act
        sut.use(potionItem: potion, on: inventory.entity!)
        
        // Assert
        XCTAssertEqual(armor.item.armorBonus, 2)
    }
    
    func testUse_damageBonus() throws {
        // Arrange
        let entityManager = EntityManager()
        
        let inventory = self.inventory(entityManager: entityManager)
        let weapon = ItemComponent(item: mockWeapon(damageDice: D4()))
        inventory.add(item: weapon)
        inventory.equip(itemComponent: weapon)
        
        let potion = potionItem(entityManager: entityManager, potionType: .damageBonus)
        inventory.items.append(potion)
        
        let sut = PotionSystem(entityManager: entityManager)

        // Act
        sut.use(potionItem: potion, on: inventory.entity!)
        
        // Assert
        let expectedDamageDice = Dice(die: D4(), numberOfDice: 1, modifier: 1)
        XCTAssertEqual(weapon.item.damageDice, expectedDamageDice)
    }
    
    func testUse_damageBonus_unequipped() throws {
        // Arrange
        let entityManager = EntityManager()
        
        let inventory = self.inventory(entityManager: entityManager)
        let weapon = ItemComponent(item: mockWeapon(damageDice: D4()))
        inventory.add(item: weapon)
        
        let potion = potionItem(entityManager: entityManager, potionType: .damageBonus)
        inventory.items.append(potion)
        
        let sut = PotionSystem(entityManager: entityManager)

        // Act
        sut.use(potionItem: potion, on: inventory.entity!)
        
        // Assert
        let expectedDamageDice = Dice(die: D4())
        XCTAssertEqual(weapon.item.damageDice, expectedDamageDice)

    }
    
    func inventory(entityManager: EntityManager) -> InventoryComponent {
        let inventory = entityManager.createEntity()
        let inventoryComponent = InventoryComponent()
        inventory.add(component: inventoryComponent)
        return inventoryComponent
    }
    
    func potionItem(entityManager: EntityManager, potionType: PotionType) -> ItemComponent {
        let potion = entityManager.createEntity()
        let item = ItemBuilder(name: "heal potion").with(potion: potionType).build()
        let itemComponent = ItemComponent(item: item)
        potion.add(component: itemComponent)
        return itemComponent
    }
    
    func mockHealTarget(entityManager: EntityManager, combatComponent: CombatComponent) -> Entity {
        let healTarget = entityManager.createEntity()
        healTarget.add(component: combatComponent)
        return healTarget
    }
}
