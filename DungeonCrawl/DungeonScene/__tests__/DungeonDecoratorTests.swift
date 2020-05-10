//
//  DungeonMapDecoratorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonDecoratorTests: XCTestCase {

    func testDecorate() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let sut = DungeonDecorator()
        
        // Act
        let decorations = sut.decorate(dungeon: dungeon)
        
        // Assert
        let tileAtStartCell = dungeon.map.tile(at: decorations.playerStartCell)
        XCTAssertEqual(tileAtStartCell, .floor)
        XCTAssertEqual(decorations.enemies.count, 1)
    }
    
    func testDecorate_noRooms() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: [])
        let sut = DungeonDecorator()
        
        // Act
        let decorations = sut.decorate(dungeon: dungeon)
        
        // Assert
        let tileAtStartCell = dungeon.map.tile(at: decorations.playerStartCell)
        XCTAssertEqual(tileAtStartCell, .floor)
        XCTAssertEqual(decorations.enemies.count, 0)
    }
}

private func threeRooms() -> [RoomModel] {
     return [
        RoomModel(bounds: GridRect(x: 1, y: 9, width: 7, height: 3)),
        RoomModel(bounds: GridRect(x: 7, y: 1, width: 3, height: 7)),
        RoomModel(bounds: GridRect(x: 13, y: 7, width: 7, height: 3))
    ]
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
