//
//  TreasurePlacerTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class TreasurePlacerTests: XCTestCase {
    
    func testPlaceTreasure_noRooms() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: [])
        let occupiedCells = OccupiedCells()
        let chance = MockChance()
        chance.mockEventHappens = true
        let sut = TreasurePlacer(chance: chance)
        
        // Act
        let items = sut.placeTreasure(in: dungeon, occupiedCells: occupiedCells)
        
        // Assert
        XCTAssert(items.isEmpty)
    }

    func testPlaceTreasure_none() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let occupiedCells = OccupiedCells()
        let chance = MockChance()
        chance.mockEventHappens = false
        let sut = TreasurePlacer(chance: chance)
        
        // Act
        let items = sut.placeTreasure(in: dungeon, occupiedCells: occupiedCells)
        
        // Assert
        XCTAssert(items.isEmpty)
    }
    
    func testPlaceTreasure_occupied() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let occupiedCells = MockOccupiedCells()
        occupiedCells.mockIsOccupied = true
        let chance = MockChance()
        chance.mockEventHappens = true
        let sut = TreasurePlacer(chance: chance)
        
        // Act
        let items = sut.placeTreasure(in: dungeon, occupiedCells: occupiedCells)
        
        // Assert
        XCTAssert(items.isEmpty)
    }
    
    func testPlaceTreasure() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let occupiedCells = MockOccupiedCells()
        occupiedCells.mockIsOccupied = false
        let chance = MockChance()
        chance.mockEventHappens = true
        let sut = TreasurePlacer(chance: chance)
        
        // Act
        let items = sut.placeTreasure(in: dungeon, occupiedCells: occupiedCells)
        
        // Assert
        XCTAssertEqual(items.count, 3)
    }
}

class MockOccupiedCells: OccupiedCells {
    
    var mockIsOccupied = false
    
    override func isOccupied(cell: GridCell) -> Bool {
        return mockIsOccupied
    }
}
