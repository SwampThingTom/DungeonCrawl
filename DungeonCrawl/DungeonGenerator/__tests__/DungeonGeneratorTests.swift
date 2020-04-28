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
        let size = CGSize(width: 200, height: 100)
        let expectedRoomCount = 0
        let sut = DungeonGenerator()
        
        // Act
        let dungeon = sut.generate(size: size)
        
        // Assert
        XCTAssertEqual(dungeon.size, size)
        XCTAssertEqual(dungeon.tiles.count, Int(size.width))
        XCTAssertEqual(dungeon.tiles[0].count, Int(size.height))
        XCTAssertEqual(dungeon.rooms.count, Int(expectedRoomCount))
    }

}
