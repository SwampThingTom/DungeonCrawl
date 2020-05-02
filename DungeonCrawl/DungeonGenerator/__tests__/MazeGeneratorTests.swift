//
//  MazeGeneratorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class MazeGeneratorTests: XCTestCase {
    
    func testGenerate_emptyGrid() throws {
        // Arrange
        let gridSize = GridSize(width: 0, height: 0)
        var map: MutableGridMap = DungeonMap(size: gridSize)
        let sut = MazeGenerator()
        
        // Act
        sut.generate(map: &map)
        
        // Assert
        XCTAssert(true) // As long as sut did not crash, the test passes
    }
    
    func testGenerate_tooSmallGrid() throws {
        // Arrange
        let gridSize = GridSize(width: 2, height: 2)
        var map: MutableGridMap = DungeonMap(size: gridSize)
        let sut = MazeGenerator()
        
        // Act
        sut.generate(map: &map)
        
        // Assert
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let location = GridPoint(x: x, y: y)
                XCTAssertEqual(map.cell(location: location), .empty)
            }
        }
    }
    
    func testGenerate_minimumMazeGrid() throws {
        // Arrange
        let gridSize = GridSize(width: 3, height: 3)
        var map: MutableGridMap = DungeonMap(size: gridSize)
        let sut = MazeGenerator()
        let expectedTiles = [
            [Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.floor, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty]
        ]
        let expectedMap = DungeonMap(tiles: expectedTiles)
        
        // Act
        sut.generate(map: &map)
        
        // Assert
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let location = GridPoint(x: x, y: y)
                XCTAssertEqual(map.cell(location: location),
                               expectedMap.cell(location: location))
            }
        }
    }
}
