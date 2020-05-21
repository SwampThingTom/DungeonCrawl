//
//  PathfinderTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/21/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class PathfinderTests: XCTestCase {

    func testEmptyMap() throws {
        // Arrange
        let map = DungeonMap()
        let sut = Pathfinder(map: map)
        
        // Act
        let path = sut.findPath(from: GridCell(x: 0, y: 0), to: GridCell(x: 5, y: 5))
        
        // Assert
        XCTAssert(path.isEmpty)
    }
    
    func testInvalidMap() throws {
        // Arrange
        let map = mapWithAllTiles(.wall, size: GridSize(width: 3, height: 3))
        let sut = Pathfinder(map: map)
        
        // Act
        let path = sut.findPath(from: GridCell(x: 0, y: 0), to: GridCell(x: 2, y: 2))
        
        // Assert
        XCTAssert(path.isEmpty)
    }
    
    func testInvalidStartCell() throws {
        // Arrange
        let map = mapWithAllTiles(.floor, size: GridSize(width: 3, height: 3))
        let sut = Pathfinder(map: map)
        
        // Act
        let path = sut.findPath(from: GridCell(x: 5, y: 5), to: GridCell(x: 0, y: 0))
        
        // Assert
        XCTAssert(path.isEmpty)
    }
    
    func testInvalidEndCell() throws {
        // Arrange
        let map = mapWithAllTiles(.floor, size: GridSize(width: 3, height: 3))
        let sut = Pathfinder(map: map)
        
        // Act
        let path = sut.findPath(from: GridCell(x: 0, y: 0), to: GridCell(x: 5, y: 5))
        
        // Assert
        XCTAssert(path.isEmpty)
    }
    
    func testSameStartAndEndCell() throws {
        // Arrange
        let map = mapWithAllTiles(.floor, size: GridSize(width: 3, height: 3))
        let sut = Pathfinder(map: map)
        
        // Act
        let path = sut.findPath(from: GridCell(x: 1, y: 1), to: GridCell(x: 1, y: 1))
        
        // Assert
        XCTAssert(path.isEmpty)
    }
    
    func testEndCellIsAdjacent() throws {
        // Arrange
        let map = mapWithAllTiles(.floor, size: GridSize(width: 3, height: 3))
        let sut = Pathfinder(map: map)
        
        // Act
        let path = sut.findPath(from: GridCell(x: 1, y: 1), to: GridCell(x: 2, y: 1))
        
        // Assert
        XCTAssertEqual(path, [GridCell(x: 2, y: 1)])
    }
    
    func testMultiplePathsToEnd() throws {
        // Arrange
        let map = mapWithCircularPath()
        let sut = Pathfinder(map: map)
        
        // Act
        let path = sut.findPath(from: GridCell(x: 1, y: 3), to: GridCell(x: 2, y: 1))
        
        // Assert
        let expectedPath = [
            GridCell(x: 1, y: 2),
            GridCell(x: 1, y: 1),
            GridCell(x: 2, y: 1)
        ]
        XCTAssertEqual(path, expectedPath)
    }
    
    func testNoPaths() throws {
        // Arrange
        let map = mapWithDisconnectedPath()
        let sut = Pathfinder(map: map)
        
        // Act
        let path = sut.findPath(from: GridCell(x: 1, y: 3), to: GridCell(x: 3, y: 2))
        
        // Assert
        XCTAssertEqual(path.count, 0)
    }
    
    func testPathAroundEdges() throws {
        // Arrange
        let map = mapWithPathAroundEdges()
        let sut = Pathfinder(map: map)
        
        // Act
        let path = sut.findPath(from: GridCell(x: 0, y: 0), to: GridCell(x: 0, y: 2))
        
        // Assert
        let expectedPath = [
            GridCell(x: 1, y: 0), GridCell(x: 2, y: 0), GridCell(x: 3, y: 0), GridCell(x: 4, y: 0),
            GridCell(x: 4, y: 1), GridCell(x: 4, y: 2), GridCell(x: 4, y: 3), GridCell(x: 4, y: 4),
            GridCell(x: 3, y: 4), GridCell(x: 2, y: 4), GridCell(x: 1, y: 4), GridCell(x: 0, y: 4),
            GridCell(x: 0, y: 3), GridCell(x: 0, y: 2)
        ]
        XCTAssertEqual(path, expectedPath)
    }

    func mapWithAllTiles(_ tile: Tile, size: GridSize) -> DungeonMap {
        let tiles = [[Tile]](repeating: [Tile](repeating: tile, count: size.width), count: size.height)
        return DungeonMap(tiles: tiles)
    }
    
    func mapWithCircularPath() -> DungeonMap {
        let tiles: [[Tile]] = [
            [.wall, .wall, .wall, .wall, .wall],
            [.wall, .floor, .floor, .floor, .wall],
            [.wall, .floor, .wall, .floor, .wall],
            [.wall, .floor, .floor, .floor, .wall],
            [.wall, .wall, .wall, .wall, .wall],
        ]
        return DungeonMap(tiles: tiles)
    }
    
    func mapWithDisconnectedPath() -> DungeonMap {
        let tiles: [[Tile]] = [
            [.wall, .wall, .wall, .wall, .wall],
            [.wall, .floor, .floor, .wall, .wall],
            [.wall, .floor, .wall, .floor, .wall],
            [.wall, .floor, .floor, .wall, .wall],
            [.wall, .wall, .wall, .wall, .wall],
        ]
        return DungeonMap(tiles: tiles)
    }
    
    func mapWithPathAroundEdges() -> DungeonMap {
        let tiles: [[Tile]] = [
            [.floor, .floor, .floor, .floor, .floor],
            [.wall, .wall, .wall, .wall, .floor],
            [.floor, .wall, .floor, .floor, .floor],
            [.floor, .wall, .wall, .wall, .floor],
            [.floor, .floor, .floor, .floor, .floor]
        ]
        return DungeonMap(tiles: tiles)
    }
}
