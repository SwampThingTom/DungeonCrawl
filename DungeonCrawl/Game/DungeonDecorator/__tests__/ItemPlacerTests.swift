//
//  ItemPlacerTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class ItemPlacerTests: XCTestCase {
    
    func testPlaceItems_noRooms() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: [])
        let occupiedCells = OccupiedCells()
        let itemPicker = MockItemPicker()
        itemPicker.mockItems = [Item(name: "Item")]
        let sut = ItemPlacer(itemPicker: itemPicker.pickItem)
        
        // Act
        let items = sut.placeItems(in: dungeon, occupiedCells: occupiedCells)
        
        // Assert
        XCTAssert(items.isEmpty)
    }

    func testPlaceItems_none() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let occupiedCells = OccupiedCells()
        let itemPicker = MockItemPicker()
        itemPicker.mockItems = [nil, nil, nil]
        let sut = ItemPlacer(itemPicker: itemPicker.pickItem)
        
        // Act
        let items = sut.placeItems(in: dungeon, occupiedCells: occupiedCells)
        
        // Assert
        XCTAssert(items.isEmpty)
    }
    
    func testPlaceItems() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let occupiedCells = OccupiedCells()
        let itemPicker = MockItemPicker()
        itemPicker.mockItems = [Item(name: "Item"), nil, Item(name: "Another Item")]
        let sut = ItemPlacer(itemPicker: itemPicker.pickItem)

        // Act
        let items = sut.placeItems(in: dungeon, occupiedCells: occupiedCells)
        
        // Assert
        XCTAssertEqual(items.count, 2)
    }
}

class MockItemPicker {
    
    private var itemIndex: Int = 0
    
    var mockItems = [Item?]()
    
    func pickItem() -> Item? {
        let item = mockItems[itemIndex]
        itemIndex += 1
        return item
    }
}
