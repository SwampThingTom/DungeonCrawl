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

/// Returns a 17x15 map with five regions.
///
///    `                      1111111`
///    `01234567890123456`
/// 00: `*****************`
/// 01: `*_*___*___*_____*`
/// 02: `*_*_*_*___*_*_*_*`
/// 03: `*___*_$___*_*_*_*`
/// 04: `***_*_*___*_***_*`
/// 05: `*_*_*_*___*___*_*`
/// 06: `*_*_***___*_***$*`
/// 07: `*_____*___*_*___*`
/// 08: `***$*******_*___*`
/// 09: `*_______*_*_*___*`
/// 10: `*_______*_*_*****`
/// 11: `*_______*_*_____*`
/// 12: `***$*****_*****_*`
/// 13: `*_______________*`
/// 14: `*****************`
private func fiveRegionMap() -> MutableGridMap {

    let tiles = [
        "_*___*___*_____",
        "_*_*_*___*_*_*_",
        "___*_$___*_*_*_",
        "**_*_*___*_***_",
        "_*_*_*___*___*_",
        "_*_***___*_***$",
        "_____*___*_*___",
        "**$*******_*___",
        "_______*_*_*___",
        "_______*_*_****",
        "_______*_*_____",
        "**$*****_*****_",
        "_______________"
    ]
    
    let mapBuilder = MockMapBuilder(size: GridSize(width: 17, height: 15))
    mapBuilder.addTiles(origin: GridCell(x: 1, y: 1), description: tiles)
    return mapBuilder.build()
}

private class MockMapBuilder {
    
    private var map: DungeonMap
    
    init(size: GridSize) {
        self.map = DungeonMap(size: size)
    }
    
    func addTiles(origin: GridCell, description gridStrings: [String]) {
        for y in 0 ..< gridStrings.count {
            let gridString = gridStrings[y]
            var x = 0
            for index in gridString.indices {
                if gridString[index] == "_" {
                    let cell = GridCell(x: origin.x + x, y: origin.y + y)
                    map.setTile(at: cell, tile: .floor)
                }
                if gridString[index] == "$" {
                    let cell = GridCell(x: origin.x + x, y: origin.y + y)
                    map.setTile(at: cell, tile: .door)
                }
                x += 1
            }
        }
    }
    
    func build() -> DungeonMap {
        return map
    }
}
