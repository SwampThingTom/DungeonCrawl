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
        let enemyPlacer = MockEnemyPlacer()
        enemyPlacer.mockedEnemies = [
            EnemyModel(enemyType: .jellyCube, cell: GridCell(x: 14, y: 8)),
            EnemyModel(enemyType: .giantBat, cell: GridCell(x: 8, y: 4))
        ]
        let sut = DungeonDecorator(enemyPlacer: enemyPlacer)
        
        // Act
        let decorations = sut.decorate(dungeon: dungeon)
        
        // Assert
        let tileAtStartCell = dungeon.map.tile(at: decorations.playerStartCell)
        XCTAssertEqual(tileAtStartCell, .floor)
        XCTAssertEqual(decorations.enemies.count, 2)
        // LATER: How should we verify decorations are being created?
        // XCTAssertGreaterThanOrEqual(decorations.items.count, 1)  // One sword + random treasure
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

class MockEnemyPlacer: EnemyPlacing {
    
    var mockedEnemies = [EnemyModel]()
    
    func placeEnemies(in dungeon: DungeonModel,
                      occupiedCells: OccupiedCells,
                      maxChallengeRating: Double) -> [EnemyModel] {
        return mockedEnemies
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
