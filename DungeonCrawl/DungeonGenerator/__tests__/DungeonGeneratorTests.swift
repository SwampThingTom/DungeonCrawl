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
        let size = CGSize(width: 320, height: 240)
        let expectedRoomCount = 1
        let sut = DungeonGenerator()
        
        // Act
        let dungeon = sut.generate(size: size)
        
        // Assert
        XCTAssertEqual(dungeon.size, size)
        XCTAssertEqual(dungeon.tiles.count, Int(size.width))
        XCTAssertEqual(dungeon.tiles[0].count, Int(size.height))
        XCTAssertEqual(dungeon.rooms.count, Int(expectedRoomCount))
        XCTAssertFalse(roomsOverlap(dungeon.rooms))
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
}
