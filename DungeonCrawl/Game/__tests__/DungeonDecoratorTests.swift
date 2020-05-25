//
//  DungeonMapDecoratorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonDecoratorTests: XCTestCase {

    func testDecorate() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let sut = DungeonDecorator()
        
        // Act
        let decorations = sut.decorate(dungeon: dungeon)
        
        // Assert
        let tileAtStartCell = dungeon.map.tile(at: decorations.playerStartCell)
        XCTAssertEqual(tileAtStartCell, .floor)
        XCTAssertEqual(decorations.enemies.count, 1)
        XCTAssertGreaterThanOrEqual(decorations.items.count, 1)  // One sword + random treasure
        XCTAssertFalse(decorationsOverlap(decorations, map: dungeon.map))
    }
    
    func testDecorate_noRooms() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: [])
        let sut = DungeonDecorator()
        
        // Act
        let decorations = sut.decorate(dungeon: dungeon)
        
        // Assert
        let tileAtStartCell = dungeon.map.tile(at: decorations.playerStartCell)
        XCTAssertEqual(tileAtStartCell, .floor)
        XCTAssertEqual(decorations.enemies.count, 0)
        XCTAssertEqual(decorations.items.count, 0)
    }
}

/// Returns true if any of the dungeon decorations are on an obstacle cell
/// or are on the same cell as another decoration.
private func decorationsOverlap(_ decorations: DungeonDecorations, map: GridMap) -> Bool {
    var occupiedCells = Set<GridCell>()
    
    let cellIsOccupied: (GridCell) -> Bool = {
        guard !occupiedCells.contains($0) else { return true }
        guard let tile = map.tile(at: $0), !tile.isObstacle else { return true }
        return false
    }
    
    guard !cellIsOccupied(decorations.playerStartCell) else { return true }
    occupiedCells.insert(decorations.playerStartCell)
    
    for enemy in decorations.enemies {
        guard !cellIsOccupied(enemy.cell) else { return true }
        occupiedCells.insert(enemy.cell)
    }
    
    for object in decorations.items {
        guard !cellIsOccupied(object.cell) else { return true }
        occupiedCells.insert(object.cell)
    }
    
    return false
}
