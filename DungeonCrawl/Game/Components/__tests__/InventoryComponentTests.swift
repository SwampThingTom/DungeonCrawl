//
//  InventoryComponentTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/26/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class InventoryComponentTests: XCTestCase {
    
    var entityManager: EntityManager!
    
    override func setUp() {
        entityManager = EntityManager()
    }
    
    override func tearDown() {
        entityManager = nil
    }
    
    func testAddItem() throws {
        // Arrange
        let item = ItemComponent(item: mockArmor(bonus: 2))
        let sut = InventoryComponent()
        
        // Act
        sut.add(item: item)
        
        // Assert
        XCTAssertEqual(sut.items.first, item)
    }
    
    func testRemoveItem() throws {
        // Arrange
        let item = ItemComponent(item: mockArmor(bonus: 2))
        let sut = InventoryComponent()
        sut.add(item: item)
        
        // Act
        sut.remove(item: item)
        
        // Assert
        XCTAssert(sut.items.isEmpty)
    }
    
    func testRemoveItem_notInInventory() throws {
        // Arrange
        let item = ItemComponent(item: mockArmor(bonus: 2))
        let sut = InventoryComponent()
        
        // Act
        sut.remove(item: item)
        
        // Assert
        XCTAssert(sut.items.isEmpty)
    }
    
    func testEquip() throws {
        // Arrange
        let item = ItemComponent(item: mockArmor(bonus: 2))
        let sut = InventoryComponent()
        sut.items.append(item)
        
        // Act
        sut.equip(itemComponent: item)
        
        // Assert
        XCTAssertEqual(sut.equippedItem(for: .armor), item)
    }
    
    func testUnequip() throws {
        // Arrange
        let item = ItemComponent(item: mockArmor(bonus: 2))
        let sut = InventoryComponent()
        sut.items.append(item)
        sut.equip(itemComponent: item)
        
        // Act
        sut.equip(itemComponent: item)
        
        // Assert
        XCTAssertNil(sut.equippedItem(for: .armor))
    }
    
    func testEquip_notEquippable() throws {
        // Arrange
        let unequippableItem = ItemComponent(item: Item(name: "Junk"))
        let sut = InventoryComponent()
        sut.items.append(unequippableItem)
        
        // Act
        sut.equip(itemComponent: unequippableItem)
        
        // Assert
        XCTAssertNil(sut.equippedItem(for: unequippableItem.item.equipmentSlot))
    }

    func itemComponent(item: Item) -> ItemComponent {
        let entity = entityManager.createEntity()
        let itemComponent = ItemComponent(item: item)
        entityManager.add(component: itemComponent, to: entity)
        return itemComponent
    }
}
