//
//  RoomGeneratorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class RoomGeneratorTests: XCTestCase {

    func testGenerate_emptyGrid() throws {
        // Arrange
        let gridSize = GridSize(width: 0, height: 0)
        let sut = RoomGenerator()
        
        // Act
        let rooms = sut.generate(gridSize: gridSize, attempts: 5)
        
        // Assert
        XCTAssertEqual(rooms.count, 0)
    }
    
    func testGenerate_tooSmallGrid() throws {
        // Arrange
        let sut = RoomGenerator()
        let gridSize = sut.roomSize

        // Act
        let rooms = sut.generate(gridSize: gridSize, attempts: 5)
        
        // Assert
        XCTAssertEqual(rooms.count, 0)
    }
    
    func testGenerate_oneRoomGrid() throws {
        // Arrange
        let sut = RoomGenerator()
        let gridSize = GridSize(width: sut.roomSize.width + 2,
                                height: sut.roomSize.height + 2)

        // Act
        let rooms = sut.generate(gridSize: gridSize, attempts: 5)
        
        // Assert
        XCTAssertEqual(rooms.count, 1)
        XCTAssert(roomsFit(rooms, grid: gridSize))
    }
    
    func testGenerate_fitMultipleRooms() throws {
        // Arrange
        let sut = RoomGenerator()
        let gridSize = GridSize(width: 30, height: 30)
        let maxRooms = 5

        // Act
        let rooms = sut.generate(gridSize: gridSize, attempts: maxRooms)
        
        // Assert
        XCTAssertLessThanOrEqual(rooms.count, maxRooms)
        XCTAssert(roomsFit(rooms, grid: gridSize))
        XCTAssertFalse(roomsOverlap(rooms))
    }
    
    func testGenerate_largeGrid() throws {
        // Arrange
        let sut = RoomGenerator()
        let gridSize = GridSize(width: 200, height: 200)
        let maxRooms = 5

        // Act
        let rooms = sut.generate(gridSize: gridSize, attempts: maxRooms)
        
        // Assert
        XCTAssertLessThanOrEqual(rooms.count, maxRooms)
        XCTAssert(roomsFit(rooms, grid: gridSize))
        XCTAssertFalse(roomsOverlap(rooms))
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
    
    func roomsFit(_ rooms: [RoomModel], grid: GridSize) -> Bool {
        for room in rooms {
            let roomOrigin = room.bounds.origin
            let roomSize = room.bounds.size
            if roomOrigin.x < 1 || roomOrigin.x + roomSize.width > grid.width - 1 ||
               roomOrigin.y < 1 || roomOrigin.y + roomSize.height > grid.height - 1 {
                return false
            }
        }
        return true
    }

}
