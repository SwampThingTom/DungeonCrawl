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
        
        let enemyModels = [
            EnemyModel(enemyType: .ghost, cell: GridCell(x: 5, y: 1)),
            EnemyModel(enemyType: .ghost, cell: GridCell(x: 13, y: 7))
        ]
        let expectedDungeonDecorations = DungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                            enemies: enemyModels)
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
        XCTAssertNotNil(sut.level.player.gameLevel)
        sut.level.actors.forEach {
            XCTAssert($0.spriteName.starts(with: "ghost_"))
            XCTAssertEqual($0.displayName, "ghost")
            XCTAssertEqual(($0 as? EnemyActor)?.enemyType, .ghost)
            XCTAssertNotNil($0.gameLevel)
        }
    }
    
    func testTakeTurn_playerOnly() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let dungeonDecorations = DungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                            enemies: [])
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = dungeonDecorations
        
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
    
    // LATER: This is more of an integration test because it uses the actual EnemyActor
    // code to determine the move it takes. It would be better to inject the EnemyActors.
    func testTakeTurn_enemyActors() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let enemyModels: [EnemyModel] = [
            // Placing this enemy next to the player's move location will cause it to attack.
            EnemyModel(enemyType: .ghost, cell: GridCell(x: 5, y: 4)),
            EnemyModel(enemyType: .ghost, cell: GridCell(x: 13, y: 7))
        ]
        let dungeonDecorations = DungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                            enemies: enemyModels)
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = dungeonDecorations
        
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize)

        // Act
        let actorAnimations = sut.takeTurn(playerAction: .move(to: GridCell(x: 5, y: 5), direction: .east))

        // Assert
        XCTAssertEqual(actorAnimations.count, 2)
        XCTAssertEqual(actorAnimations.first?.actor as? PlayerActor, sut.level.player as? PlayerActor)
        XCTAssertEqual(actorAnimations.first?.animation, Animation.move(to: GridCell(x: 5, y: 5), heading: .east))
        XCTAssertEqual(actorAnimations[1].actor as? EnemyActor, sut.level.actors[0] as? EnemyActor)
        XCTAssertEqual(actorAnimations[1].animation, Animation.attack(heading: .south))
    }
    
    func testTakeTurn_removeDeadActors() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let enemyModels: [EnemyModel] = [
            EnemyModel(enemyType: .ghost, cell: GridCell(x: 5, y: 1)),
            EnemyModel(enemyType: .ghost, cell: GridCell(x: 13, y: 7))
        ]
        let dungeonDecorations = DungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                            enemies: enemyModels)
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = dungeonDecorations
        
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize)
        let deadEnemy = sut.level.actors[0] as? EnemyActor
        deadEnemy?.hitPoints = -1

        // Act
        let actorAnimations = sut.takeTurn(playerAction: .move(to: GridCell(x: 5, y: 5), direction: .east))

        // Assert
        XCTAssertEqual(actorAnimations.count, 2)
        XCTAssertEqual(actorAnimations.first?.actor as? PlayerActor, sut.level.player as? PlayerActor)
        XCTAssertEqual(actorAnimations.first?.animation, Animation.move(to: GridCell(x: 5, y: 5), heading: .east))
        XCTAssertEqual(actorAnimations[1].actor as? EnemyActor, deadEnemy)
        XCTAssertEqual(actorAnimations[1].animation, Animation.death)
        XCTAssertEqual(sut.level.actors.count, 1)
    }

}

class MockDungeonGenerator: DungeonGenerating {
    
    var mockGenerateDungeonModel: DungeonModel?
    var generateGridSize: GridSize?
    
    func generate(size: GridSize) -> DungeonModel {
        generateGridSize = size
        return mockGenerateDungeonModel!
    }
}

class MockDungeonDecorator: DungeonDecorating {
    
    var mockDecorations: DungeonDecorations?
    
    func decorate(dungeon: DungeonModel) -> DungeonDecorations {
        return mockDecorations!
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
        return lhs.spriteName == rhs.spriteName && lhs.cell == rhs.cell
    }
}

extension EnemyActor: Equatable {
    public static func == (lhs: EnemyActor, rhs: EnemyActor) -> Bool {
        return lhs.spriteName == rhs.spriteName && lhs.cell == rhs.cell && lhs.enemyType == rhs.enemyType
    }

}
