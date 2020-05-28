//
//  DungeonSceneInventoryTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/24/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonSceneInventoryTests: XCTestCase {
    
    var entityManager: EntityManager!
    
    override func setUp() {
        entityManager = EntityManager()
    }
    
    override func tearDown() {
        entityManager = nil
    }
    
    func testInventoryViewModel_empty() throws {
        // Arrange
        let inventoryComponent = InventoryComponent()
        
        // Act
        let sut = inventoryViewModel(for: inventoryComponent, equipHandler: mockActionHandler)
        
        // Assert
        XCTAssertEqual(sut.items.count, 0)
    }
    
    func testInventoryViewModel_items() throws {
        // Arrange
        let items = [
            itemComponent(item: mockArmor(bonus: 2, name: "Leather")),
            itemComponent(item: mockWeapon(damageDice: D3(), name: "Dagger")),
            itemComponent(item: Item(name: "Junk")),
        ]
        let inventoryComponent = InventoryComponent()
        inventoryComponent.items.append(contentsOf: items)
        
        // Act
        let sut = inventoryViewModel(for: inventoryComponent, equipHandler: mockActionHandler)
        
        // Assert
        XCTAssertEqual(sut.items.count, 3)
        
        XCTAssertEqual(sut.items[0].name, "Armor: Leather (12)")
        XCTAssertEqual(sut.items[0].actions.count, 1)
        XCTAssertEqual(sut.items[0].actions.first?.name, "Equip")
        
        XCTAssertEqual(sut.items[1].name, "Weapon: Dagger (d3)")
        XCTAssertEqual(sut.items[1].actions.count, 1)
        XCTAssertEqual(sut.items[1].actions.first?.name, "Equip")

        XCTAssertEqual(sut.items[2].name, "Other: Junk")
        XCTAssert(sut.items[2].actions.isEmpty)
    }
    
    func testInventoryViewModel_equippedItems() throws {
        // Arrange
        let items = [
            itemComponent(item: mockArmor(bonus: 2, name: "Leather")),
            itemComponent(item: mockWeapon(damageDice: D3(), name: "Dagger")),
            itemComponent(item: mockWeapon(damageDice: D3(), name: "Dagger")),
            itemComponent(item: Item(name: "Junk")),
        ]
        let inventoryComponent = InventoryComponent()
        inventoryComponent.items.append(contentsOf: items)
        inventoryComponent.equip(itemComponent: items[0])
        inventoryComponent.equip(itemComponent: items[1])

        // Act
        let sut = inventoryViewModel(for: inventoryComponent, equipHandler: mockActionHandler)

        // Assert
        XCTAssertEqual(sut.items.count, 4)
        XCTAssertEqual(sut.items[0].name, "Armor: Leather (12) (equipped)")
        XCTAssertEqual(sut.items[0].actions.count, 1)
        XCTAssertEqual(sut.items[0].actions.first?.name, "Unequip")

        XCTAssertEqual(sut.items[1].name, "Weapon: Dagger (d3) (equipped)")
        XCTAssertEqual(sut.items[1].actions.count, 1)
        XCTAssertEqual(sut.items[1].actions.first?.name, "Unequip")
        
        XCTAssertEqual(sut.items[2].name, "Weapon: Dagger (d3)")
        XCTAssertEqual(sut.items[2].actions.count, 1)
        XCTAssertEqual(sut.items[2].actions.first?.name, "Equip")

        XCTAssertEqual(sut.items[3].name, "Other: Junk")
        XCTAssert(sut.items[3].actions.isEmpty)
    }
    
    func itemComponent(item: Item) -> ItemComponent {
        let entity = entityManager.createEntity()
        let itemComponent = ItemComponent(item: item)
        entityManager.add(component: itemComponent, to: entity)
        return itemComponent
    }
    
    func mockActionHandler(itemID: UInt) -> InventoryViewModel {
        return InventoryViewModel(items: [])
    }
}
