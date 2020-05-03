//
//  DungeonGeneratorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonGeneratorTests: XCTestCase {

    func testGenerate() {
        // Arrange
        let size = GridSize(width: 100, height: 100)
        let maxRooms = 5
        let sut = DungeonGenerator(roomAttempts: maxRooms)
        
        // Act
        let dungeon = sut.generate(size: size)
        
        // Assert
        XCTAssertEqual(dungeon.map.size, size)
        XCTAssertGreaterThan(dungeon.rooms.count, 0)
        XCTAssertLessThanOrEqual(dungeon.rooms.count, maxRooms)
        XCTAssert(roomTilesAreFilled(dungeon))
        
        // TODO: Add this test back when ready to verify this functionality
        // XCTAssert(allRoomsAreReachable(dungeon))
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
                let location = GridPoint(x: x, y: y)
                if map.cell(location: location) != expected {
                    return false
                }
            }
        }
        return true
    }
        
    //    func allRoomsAreReachable(_ dungeon: DungeonModel) -> Bool {
    //        guard let startTile = findStartTile(dungeon) else { return false }
    //        for room in dungeon.rooms {
    //            if !pathExists(from: startTile, to: room.bounds.origin, in: dungeon) {
    //                return false
    //            }
    //        }
    //        return true
    //    }

//    func findStartTile(_ dungeon: DungeonModel) -> GridPoint? {
//        for x in 0 ..< dungeon.size.width {
//            for y in 0 ..< dungeon.size.height {
//                if dungeon.tiles[x][y] == .floor {
//                    return GridPoint(x: x, y: y)
//                }
//            }
//        }
//        return nil
//    }
    
//    func pathExists(from start: GridPoint, to end: GridPoint, in dungeon: DungeonModel) -> Bool {
//        let pathfinder = Pathfinder(tiles: dungeon.tiles)
//        return pathfinder.findPath(from: start, to: end).count > 0
//    }
}
