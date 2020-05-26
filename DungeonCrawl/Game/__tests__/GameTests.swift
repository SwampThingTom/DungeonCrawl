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
        let items = [
            ItemModel(item: createTreasure(worth: 10), cell: GridCell(x: 7, y: 10)),
            ItemModel(item: createTreasure(worth: 50), cell: GridCell(x: 15, y: 7))
        ]
        let expectedDungeonDecorations = mockDungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                                enemies: enemyModels,
                                                                items: items)
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
        
        // Don't include items that don't have a sprite.
        let itemsOnMap = sut.level.items.filter { $0.spriteComponent() != nil }
        XCTAssertEqual(itemsOnMap.count, expectedDungeonDecorations.items.count)
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

class MockQuest: QuestStatusProviding {
    
    var mockIsComplete: Bool = false
    
    func isComplete(gameLevel: DungeonLevel) -> Bool {
        return mockIsComplete
    }
}
