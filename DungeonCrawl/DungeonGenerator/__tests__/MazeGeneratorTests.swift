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
        let mapSource = MockMapSource.emptyMap(size: gridSize)
        let sut = MazeGenerator()
        
        // Act
        sut.generate(mapSource: mapSource)
        
        // Assert
        XCTAssertEqual(mapSource.carvedTiles.count, 0)
    }
}

struct MockMapSource: MazeMapSource {
    
    private var tiles: [[Tile]]
    
    var size: GridSize {
        guard tiles.count > 0 else { return GridSize(width: 0, height: 0) }
        return GridSize(width: tiles.count, height: tiles[0].count)
    }
    
    init(tiles: [[Tile]]) {
        self.tiles = tiles
    }
    
    func cell(location: GridPoint) -> Tile? {
        return nil
    }
    func openTiles() -> [GridPoint] {
        return []
    }
    
    var carvedTiles = [GridPoint]()
    
    mutating func carve(tile: GridPoint) {
        carvedTiles.append(tile)
    }
}

extension MockMapSource {
    
    static func emptyMap(size: GridSize) -> MockMapSource {
        return MockMapSource(tiles: [])
    }
}
