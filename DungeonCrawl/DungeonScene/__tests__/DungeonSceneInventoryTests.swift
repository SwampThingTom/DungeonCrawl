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

    func testInventoryViewModel_empty() throws {
        // Arrange
        let inventoryComponent = InventoryComponent()
        
        // Act
        let sut = inventoryViewModel(for: inventoryComponent)
        
        // Assert
        XCTAssertEqual(sut.items.count, 0)
    }
    
    func testInventoryViewModel_items() throws {
        // Arrange
        let items = [
            mockArmor(bonus: 2, name: "Leather"),
            mockWeapon(damageDie: D3(), name: "Dagger"),
            Item(name: "Junk"),
        ]
        let inventoryComponent = InventoryComponent()
        inventoryComponent.items = items
        
        // Act
        let sut = inventoryViewModel(for: inventoryComponent)
        
        // Assert
        XCTAssertEqual(sut.items.count, 3)
        XCTAssertEqual(sut.items[0].name, "Armor: Leather (12)")
        XCTAssertEqual(sut.items[1].name, "Weapon: Dagger (d3)")
        XCTAssertEqual(sut.items[2].name, "Other: Junk")
    }
    
    func testInventoryViewModel_equippedItems() throws {
        // Arrange
        let items = [
            mockArmor(bonus: 2, name: "Leather"),
            mockWeapon(damageDie: D3(), name: "Dagger"),
            Item(name: "Junk"),
        ]
        let inventoryComponent = InventoryComponent()
        inventoryComponent.items = items
        inventoryComponent.equip(item: items[0])
        inventoryComponent.equip(item: items[1])

        // Act
        let sut = inventoryViewModel(for: inventoryComponent)

        // Assert
        XCTAssertEqual(sut.items.count, 3)
        XCTAssertEqual(sut.items[0].name, "Armor: Leather (12) (equipped)")
        XCTAssertEqual(sut.items[1].name, "Weapon: Dagger (d3) (equipped)")
        XCTAssertEqual(sut.items[2].name, "Other: Junk")
    }
}
