//
//  PlayerTurnActionSystemTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/19/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class PlayerTurnActionSystemTests: XCTestCase {

    func testTurnActionForMapTouch_invalidTile() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let player = entityFactory.createPlayer(cell: GridCell(x: 0, y: 0))
        let level = MockGameLevel(player: player, actors: [])
        let sut = PlayerTurnActionSystem(entityManager: entityManager, gameLevel: level)
        
        // Act
        let action = sut.turnActionForMapTouch(direction: .west, playerSprite: player.spriteComponent()!)
        
        // Assert
        XCTAssertNil(action)
    }
    
    func testTurnActionForMapTouch_obstacleTile() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let player = entityFactory.createPlayer(cell: GridCell(x: 11, y: 5))
        let level = MockGameLevel(player: player, actors: [])
        let sut = PlayerTurnActionSystem(entityManager: entityManager, gameLevel: level)
        
        // Act
        let action = sut.turnActionForMapTouch(direction: .west, playerSprite: player.spriteComponent()!)
        
        // Assert
        XCTAssertNil(action)
    }
    
    func testTurnActionForMapTouch_move() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let player = entityFactory.createPlayer(cell: GridCell(x: 11, y: 5))
        let enemy = entityFactory.createEnemy(enemyType: .ghost, cell: GridCell(x: 15, y: 5))
        let level = MockGameLevel(player: player, actors: [enemy])
        let sut = PlayerTurnActionSystem(entityManager: entityManager, gameLevel: level)
        
        // Act
        let action = sut.turnActionForMapTouch(direction: .east, playerSprite: player.spriteComponent()!)
        
        // Assert
        XCTAssertEqual(action, TurnAction.move(to: GridCell(x: 12, y: 5), direction: .east))
    }

    func testTurnActionForMapTouch_enemy() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let player = entityFactory.createPlayer(cell: GridCell(x: 11, y: 5))
        let enemy = entityFactory.createEnemy(enemyType: .ghost, cell: GridCell(x: 12, y: 5))
        let level = MockGameLevel(player: player, actors: [enemy])
        let sut = PlayerTurnActionSystem(entityManager: entityManager, gameLevel: level)
        
        // Act
        let action = sut.turnActionForMapTouch(direction: .east, playerSprite: player.spriteComponent()!)
        
        // Assert
        XCTAssertEqual(action, TurnAction.attack(direction: .east))
    }
}
