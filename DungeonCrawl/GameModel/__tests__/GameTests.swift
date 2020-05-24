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
        let expectedRooms = threeRooms()
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: expectedRooms)
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let enemyModels = [
            EnemyModel(enemyType: .ghost, cell: GridCell(x: 5, y: 1)),
            EnemyModel(enemyType: .ghost, cell: GridCell(x: 13, y: 7))
        ]
        let dungeonObjects = [
            DungeonObject(objectType: .urn, gold: 10, cell: GridCell(x: 7, y: 10)),
            DungeonObject(objectType: .urn, gold: 50, cell: GridCell(x: 15, y: 7))
        ]
        let expectedDungeonDecorations = mockDungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                                enemies: enemyModels,
                                                                objects: dungeonObjects)
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = expectedDungeonDecorations
        
        // Act
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize,
                       quest: MockQuest())
        
        // Assert
        XCTAssertEqual(dungeonGenerator.generateGridSize, dungeonSize)
        XCTAssertEqual(sut.level.map.size, dungeonSize)
        XCTAssertEqual(sut.level.rooms, expectedRooms)
        
        let playerSprite = sut.entityManager.spriteComponent(for: sut.level.player)!
        XCTAssertEqual(playerSprite.cell, expectedDungeonDecorations.playerStartCell)
        
        XCTAssertEqual(sut.level.actors.count, expectedDungeonDecorations.enemies.count)
        
        var enemyModelCells = Set<GridCell>([enemyModels[0].cell, enemyModels[1].cell])
        sut.level.actors.enumerated().forEach {
            // Verify enemy cell is one of the expected cells
            let enemySprite = sut.entityManager.spriteComponent(for: $1)!
            XCTAssert(enemyModelCells.contains(enemySprite.cell))
            enemyModelCells.remove(enemySprite.cell)
            
            let enemyEnemyComponent = sut.entityManager.enemyComponent(for: $1)!
            XCTAssertEqual(enemyEnemyComponent.enemyType, .ghost)
        }
        XCTAssert(enemyModelCells.isEmpty)
        
        XCTAssertEqual(sut.level.objects.count, expectedDungeonDecorations.objects.count)
    }
    
    func testTakeTurn_playerOnly() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let dungeonDecorations = mockDungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                        enemies: [])
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = dungeonDecorations
        
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize,
                       quest: MockQuest())
        
        // Act
        let spriteAnimations = sut.takeTurn(playerAction: .move(to: GridCell(x: 5, y: 5), direction: .east))
        
        // Assert
        XCTAssertEqual(spriteAnimations.count, 1)
        XCTAssertEqual(spriteAnimations.first?.spriteName, sut.level.player.spriteComponent()!.spriteName)
        XCTAssertEqual(spriteAnimations.first?.animation, Animation.move(to: GridCell(x: 5, y: 5), heading: .east))
    }
    
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
        let dungeonDecorations = mockDungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                        enemies: enemyModels)
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = dungeonDecorations
        
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize,
                       quest: MockQuest())
        
        let enemyTurnActionSystem = MockEnemyTurnActionSystem()
        enemyTurnActionSystem.turnActionForEnemy = [
            sut.level.actors[0]: .attack(direction: .south),
            sut.level.actors[1]: .nothing
        ]
        sut.enemyTurnActionSystem = enemyTurnActionSystem
        sut.turnTakingSystem = MockTurnTakingSystem()
        
        let expectedPlayerSpriteName = sut.level.player.spriteComponent()!.spriteName
        let expectedAttackSpriteName = sut.level.actors[0].spriteComponent()!.spriteName
        
        // Act
        let spriteAnimations = sut.takeTurn(playerAction: .move(to: GridCell(x: 5, y: 5), direction: .east))
        
        // Assert
        XCTAssertEqual(spriteAnimations.count, 2)
        
        let playerSpriteAnimation = spriteAnimations[0]
        let enemyAttackAnimation = spriteAnimations[1]
        
        XCTAssertEqual(playerSpriteAnimation.spriteName, expectedPlayerSpriteName)
        XCTAssertEqual(playerSpriteAnimation.animation, Animation.move(to: GridCell(x: 5, y: 5), heading: .east))
        XCTAssertEqual(enemyAttackAnimation.spriteName, expectedAttackSpriteName)
        XCTAssertEqual(enemyAttackAnimation.animation, Animation.attack(heading: .south))
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
        let dungeonDecorations = mockDungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                        enemies: enemyModels)
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = dungeonDecorations
        
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize,
                       quest: MockQuest())
        
        let enemyTurnActionSystem = MockEnemyTurnActionSystem()
        enemyTurnActionSystem.turnActionForEnemy = [
            sut.level.actors[0]: .nothing,
            sut.level.actors[1]: .nothing
        ]
        sut.enemyTurnActionSystem = enemyTurnActionSystem
        
        let deadEnemy = sut.level.actors[0]
        let deadEnemyCombat = sut.entityManager.combatComponent(for: deadEnemy)!
        deadEnemyCombat.hitPoints = -1
        let expectedDeadEnemySpriteName = deadEnemy.spriteComponent()!.spriteName
        
        // Act
        let spriteAnimations = sut.takeTurn(playerAction: .move(to: GridCell(x: 5, y: 5), direction: .east))
        
        // Assert
        XCTAssertEqual(spriteAnimations.count, 2)
        XCTAssertEqual(spriteAnimations.first?.spriteName, sut.level.player.spriteComponent()!.spriteName)
        XCTAssertEqual(spriteAnimations.first?.animation, Animation.move(to: GridCell(x: 5, y: 5), heading: .east))
        XCTAssertEqual(spriteAnimations[1].spriteName, expectedDeadEnemySpriteName)
        XCTAssertEqual(spriteAnimations[1].animation, Animation.death)
        XCTAssertEqual(sut.level.actors.count, 1)
    }
    
    func testIsPlayerDead_false() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let expectedDungeonDecorations = mockDungeonDecorations(playerStartCell: GridCell(x: 1, y: 13), enemies: [])
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = expectedDungeonDecorations
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize,
                       quest: MockQuest())
        
        // Act
        let isPlayerDead = sut.isPlayerDead
        
        // Assert
        XCTAssertFalse(isPlayerDead)
    }
    
    func testIsPlayerDead_true() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let expectedDungeonDecorations = mockDungeonDecorations(playerStartCell: GridCell(x: 1, y: 13), enemies: [])
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = expectedDungeonDecorations
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize,
                       quest: MockQuest())
        sut.level.player.combatComponent()?.hitPoints = -1
        
        // Act
        let isPlayerDead = sut.isPlayerDead
        
        // Assert
        XCTAssertTrue(isPlayerDead)
    }
    
    func testIsQuestComplete_false() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let expectedDungeonDecorations = mockDungeonDecorations(playerStartCell: GridCell(x: 1, y: 13), enemies: [])
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = expectedDungeonDecorations
        
        let mockQuest = MockQuest()
        mockQuest.mockIsComplete = false
        
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize,
                       quest: mockQuest)
        
        // Act
        let isQuestComplete = sut.isQuestComplete
        
        // Assert
        XCTAssertFalse(isQuestComplete)
    }
    
    func testIsQuestComplete_true() throws {
        // Arrange
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        let dungeonSize = expectedDungeonModel.map.size
        
        let expectedDungeonDecorations = mockDungeonDecorations(playerStartCell: GridCell(x: 1, y: 13), enemies: [])
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = expectedDungeonDecorations
        
        let mockQuest = MockQuest()
        mockQuest.mockIsComplete = true
        
        let sut = Game(dungeonGenerator: dungeonGenerator,
                       dungeonDecorator: dungeonDecorator,
                       dungeonSize: dungeonSize,
                       quest: mockQuest)
        
        // Act
        let isQuestComplete = sut.isQuestComplete
        
        // Assert
        XCTAssertTrue(isQuestComplete)
    }
}

class MockEnemyTurnActionSystem: EnemyTurnActionProviding {
    
    var turnActionForEnemy = [Entity: TurnAction]()
    
    func turnAction(for enemy: EnemyComponent, with sprite: SpriteComponent) -> TurnAction {
        guard
            let entity = enemy.entity,
            let turnAction = turnActionForEnemy[entity] else {
                return .nothing
        }
        return turnAction
    }
}

class MockTurnTakingSystem: TurnTaking {
    
    func doTurnAction(_ action: TurnAction,
                               for actor: Entity,
                               actorSprite: SpriteComponent) -> Animation? {
        switch action {
        case .attack(let direction):
            return .attack(heading: direction)
        case .move(let cell, let direction):
            return .move(to: cell, heading: direction)
        default:
            return nil
        }
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

private func mockDungeonDecorations(playerStartCell: GridCell,
                                    enemies: [EnemyModel],
                                    objects: [DungeonObject] = []) -> DungeonDecorations {
    return DungeonDecorations(playerStartCell: playerStartCell, enemies: enemies, objects: objects)
}

private func threeRooms() -> [RoomModel] {
    return [
        RoomModel(bounds: GridRect(x: 1, y: 9, width: 7, height: 3)),
        RoomModel(bounds: GridRect(x: 7, y: 1, width: 3, height: 7)),
        RoomModel(bounds: GridRect(x: 13, y: 7, width: 3, height: 7))
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

class MockQuest: QuestStatusProviding {
    
    var mockIsComplete: Bool = false
    
    func isComplete(gameLevel: LevelProviding) -> Bool {
        return mockIsComplete
    }
}
