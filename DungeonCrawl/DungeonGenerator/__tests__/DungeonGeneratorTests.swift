//
//  DungeonGeneratorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonGeneratorTests: XCTestCase {
    
    /// A map big enough for a single room.
    func testGenerate_tinyMap() {
        // Arrange
        let size = GridSize(width: 9, height: 9)
        let maxRooms = 5
        let sut = DungeonGenerator(roomAttempts: maxRooms)
        
        // Act
        let dungeon = sut.generate(size: size)
        
        // Assert
        XCTAssertEqual(dungeon.map.size, size)
        XCTAssertEqual(dungeon.rooms.count, 1)
        XCTAssert(allRoomsAreReachable(dungeon))
        XCTAssert(dungeon.map.hasNoDeadEnds)
    }
    
    /// A map big enough for two rooms.
    func testGenerate_smallMap() {
        // Arrange
        let size = GridSize(width: 25, height: 25)
        let maxRooms = 5
        let sut = DungeonGenerator(roomAttempts: maxRooms)
        
        // Act
        let dungeon = sut.generate(size: size)
        
        // Assert
        XCTAssertEqual(dungeon.map.size, size)
        XCTAssertGreaterThanOrEqual(dungeon.rooms.count, 2)
        XCTAssertLessThanOrEqual(dungeon.rooms.count, maxRooms)
        XCTAssert(allRoomsAreReachable(dungeon))
        XCTAssert(dungeon.map.hasNoDeadEnds)
    }
    
    /// A map big enough for three rooms.
    func testGenerate_mediumMap() {
        // Arrange
        let size = GridSize(width: 39, height: 39)
        let maxRooms = 5
        let sut = DungeonGenerator(roomAttempts: maxRooms)
        
        // Act
        let dungeon = sut.generate(size: size)
        
        // Assert
        XCTAssertEqual(dungeon.map.size, size)
        XCTAssertGreaterThanOrEqual(dungeon.rooms.count, 3)
        XCTAssertLessThanOrEqual(dungeon.rooms.count, maxRooms)
        XCTAssert(allRoomsAreReachable(dungeon))
        XCTAssert(dungeon.map.hasNoDeadEnds)
    }

    /// A map big enough for 3 to 5 rooms.
    func testGenerate_largeMap() {
        // Arrange
        let size = GridSize(width: 61, height: 45)
        let maxRooms = 5
        let sut = DungeonGenerator(roomAttempts: maxRooms)
        
        // Act
        let dungeon = sut.generate(size: size)
        
        // Assert
        XCTAssertEqual(dungeon.map.size, size)
        XCTAssertGreaterThanOrEqual(dungeon.rooms.count, 3)
        XCTAssertLessThanOrEqual(dungeon.rooms.count, maxRooms)
        XCTAssert(allRoomsAreReachable(dungeon))
        XCTAssert(dungeon.map.hasNoDeadEnds)
    }
    
    /// A very large map.
    func testGenerate_veryLargeMap() {
        // Arrange
        let size = GridSize(width: 99, height: 99)
        let maxRooms = 5
        let sut = DungeonGenerator(roomAttempts: maxRooms)
        
        // Act
        let dungeon = sut.generate(size: size)
        
        // Assert
        XCTAssertEqual(dungeon.map.size, size)
        XCTAssertGreaterThanOrEqual(dungeon.rooms.count, 4)
        XCTAssertLessThanOrEqual(dungeon.rooms.count, maxRooms)
        XCTAssert(allRoomsAreReachable(dungeon))
        XCTAssert(dungeon.map.hasNoDeadEnds)
    }
    
    func testPerformance() throws {
        let size = GridSize(width: 99, height: 99)
        let maxRooms = 5
        
        self.measure {
            let sut = DungeonGenerator(roomAttempts: maxRooms)
            _ = sut.generate(size: size)
        }
    }
    
    func roomTilesAreFilled(_ dungeon: DungeonModel) -> Bool {
        for room in dungeon.rooms {
            if !tilesMatch(dungeon.map, bounds: room.bounds, expected: .floor) {
                return false
            }
        }
        return true
    }
    
    func tilesMatch(_ map: GridMap, bounds: GridRect, expected: Tile) -> Bool {
        for x in bounds.gridXRange {
            for y in bounds.gridYRange {
                let location = GridCell(x: x, y: y)
                if map.tile(at: location) != expected {
                    return false
                }
            }
        }
        return true
    }
    
    func allRoomsAreReachable(_ dungeon: DungeonModel) -> Bool {
        guard let startCell = findStartCell(dungeon.map) else { return false }
        for room in dungeon.rooms {
            if !pathExists(from: startCell, to: room.bounds.origin, in: dungeon) {
                return false
            }
        }
        return true
    }
    
    func findStartCell(_ map: GridMap) -> GridCell? {
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let location = GridCell(x: x, y: y)
                if map.tile(at: location) == .floor {
                    return GridCell(x: x, y: y)
                }
            }
        }
        return nil
    }
    
    func pathExists(from start: GridCell, to end: GridCell, in dungeon: DungeonModel) -> Bool {
        let pathfinder = Pathfinder(map: dungeon.map)
        return pathfinder.findPath(from: start, to: end).count > 0
    }
}
