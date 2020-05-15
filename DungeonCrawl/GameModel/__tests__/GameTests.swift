//
//  GameTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class GameTests: XCTestCase {

    func testInit() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let expectedDungeonDecorations = DungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                            enemies: [])
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = expectedDungeonDecorations
        
        // Act
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize)

        // Assert
        XCTAssertEqual(dungeonGenerator.generateGridSize, dungeonSize)
        XCTAssertEqual(sut.level.map.size, dungeonSize)
        XCTAssertEqual(sut.level.player.cell, expectedDungeonDecorations.playerStartCell)
        XCTAssertEqual(sut.level.actors.count, expectedDungeonDecorations.enemies.count)
    }
    
    func testTakeTurn() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let expectedDungeonDecorations = DungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                            enemies: [])
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = expectedDungeonDecorations
        
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize)

        // Act
        let actorAnimations = sut.takeTurn(playerAction: .move(to: GridCell(x: 5, y: 5), direction: .east))

        // Assert
        XCTAssertEqual(actorAnimations.count, 1)
        XCTAssertEqual(actorAnimations.first?.actor as? PlayerActor, sut.level.player as? PlayerActor)
        XCTAssertEqual(actorAnimations.first?.animation, Animation.move(to: GridCell(x: 5, y: 5), heading: .east))
    }
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

extension PlayerActor: Equatable {
    public static func == (lhs: PlayerActor, rhs: PlayerActor) -> Bool {
        return lhs.name == rhs.name && lhs.cell == rhs.cell
    }
}
