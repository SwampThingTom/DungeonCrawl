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
        let size = TileSize(width: 320, height: 240)
        let expectedRoomCount = 5
        let randomNumberGenerator = SeededRandomNumberGenerator(seed: "testGenerate".data(using: .utf8)!)
        let sut = DungeonGenerator(roomAttempts: 5, randomNumberGenerator: randomNumberGenerator)
        
        // Act
        let dungeon = sut.generate(size: size)
        
        // Assert
        XCTAssertEqual(dungeon.size, size)
        XCTAssertEqual(dungeon.tiles.count, size.width)
        XCTAssertEqual(dungeon.tiles[0].count, size.height)
        XCTAssertEqual(dungeon.rooms.count, expectedRoomCount)
        XCTAssertFalse(roomsOverlap(dungeon.rooms))
        XCTAssert(roomTilesAreFilled(dungeon))
    }

    func roomsOverlap(_ rooms: [RoomModel]) -> Bool {
        for roomIndex in 0 ..< rooms.count - 1 {
            let room = rooms[roomIndex]
            for otherRoomIndex in roomIndex + 1 ..< rooms.count {
                let otherRoom = rooms[otherRoomIndex]
                if room.bounds.intersects(otherRoom.bounds) {
                    return true
                }
            }
        }
        return false
    }
    
    func roomTilesAreFilled(_ dungeon: DungeonModel) -> Bool {
        for room in dungeon.rooms {
            if !tilesMatch(dungeon.tiles, bounds: room.bounds, expected: .floor) {
                return false
            }
        }
        return true
    }
    
    func tilesMatch(_ tiles: [[Tile]], bounds: TileRect, expected: Tile) -> Bool {
        for x in bounds.origin.x ..< bounds.origin.x + bounds.size.width {
            for y in bounds.origin.y ..< bounds.origin.y + bounds.size.height {
                if tiles[x][y] != expected {
                    return false
                }
            }
        }
        return true
    }
}
