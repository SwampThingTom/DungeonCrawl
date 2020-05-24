//
//  DeadEndRemoverTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/4/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DeadEndRemoverTests: XCTestCase {

    func testRemoveDeadEnds_noMap() throws {
        // Arrange
        var map = emptyMap()
        let sut = DeadEndRemover()
        
        // Act
        sut.removeDeadEnds(from: &map)
        
        // Assert
        XCTAssert(map.hasNoDeadEnds)
    }
    
    func testRemoveDeadEnds_singleTileMap() throws {
        // Arrange
        var map = singleTileMap()
        let sut = DeadEndRemover()
        
        // Act
        sut.removeDeadEnds(from: &map)
        
        // Assert
        XCTAssert(map.hasNoDeadEnds)
    }
    
    func testRemoveDeadEnds() throws {
        // Arrange
        var map = fiveRegionMap()
        let sut = DeadEndRemover()
        
        // Act
        sut.removeDeadEnds(from: &map)
        
        // Assert
        XCTAssert(map.hasNoDeadEnds)
    }
}

extension GridMap {
    
    var hasNoDeadEnds: Bool {
        for x in 0 ..< size.width {
            for y in 0 ..< size.height {
                let location = GridCell(x: x, y: y)
                guard tile(at: location) != .wall else {
                    continue
                }
                if exitCount(for: location) == 1 {
                    return false
                }
            }
        }
        return true
    }
    
    func exitCount(for location: GridCell) -> Int {
        var exitCount = 0
        for neighbor in neighboringCells(location) {
            guard let cell = tile(at: neighbor.cell) else {
                continue
            }
            switch cell {
            case .floor:
                exitCount += 1
            case .door:
                exitCount += 1
            case .wall:
                break
            }
        }
        return exitCount
    }
}

/// Returns a 0x0 map.
private func emptyMap() -> MutableGridMap {
    let mapBuilder = MockMapBuilder(size: GridSize(width: 0, height: 0))
    return mapBuilder.build()
}

/// Returns a 3x3 map with a single floor tile.
///
/// `***`
/// `*_*`
/// `***`
private func singleTileMap() -> MutableGridMap {
    let mapBuilder = MockMapBuilder(size: GridSize(width: 3, height: 3))
    mapBuilder.addTiles(origin: GridCell(x: 1, y: 1), description: ["_"])
    return mapBuilder.build()
}
