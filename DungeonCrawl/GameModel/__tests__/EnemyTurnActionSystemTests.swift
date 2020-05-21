//
//  EnemyTurnActionSystemTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class EnemyTurnActionSystemTests: XCTestCase {

    var entityManager: EntityManager?
    var entityFactory: EntityFactory?
    
    override func setUp() {
        entityManager = EntityManager()
        entityFactory = EntityFactory(entityManager: entityManager!)
    }
    
    override func tearDown() {
        entityManager = nil
        entityFactory = nil
    }
    
    func testTurnAction_attack_playerInRange() throws {
        // Arrange
        let player = entityFactory!.createPlayer(cell: GridCell(x: 4, y: 5))
        let actor = entityFactory!.createEnemy(enemyType: .ghost, cell: GridCell(x: 5, y: 5))
        let actorEnemy = entityManager!.enemyComponent(for: actor)
        let actorSprite = entityManager!.spriteComponent(for: actor)
        let level = MockGameLevel(player: player, actors: [actor])
        let sut = EnemyTurnActionSystem(entityManager: entityManager!, gameLevel: level)

        // Act
        let action = sut.turnAction(for: actorEnemy!, with: actorSprite!)
        
        // Assert
        XCTAssertEqual(action, TurnAction.attack(direction: .west))
    }
    
    func testTurnAction_walk_noTarget() throws {
        // Arrange
        let player = entityFactory!.createPlayer(cell: GridCell(x: 0, y: 0))
        let actor = entityFactory!.createEnemy(enemyType: .ghost, cell: GridCell(x: 5, y: 5))
        let actorEnemy = entityManager!.enemyComponent(for: actor)
        actorEnemy?.targetCell = nil
        let actorSprite = entityManager!.spriteComponent(for: actor)
        let level = MockGameLevel(player: player, actors: [actor])
        let sut = EnemyTurnActionSystem(entityManager: entityManager!, gameLevel: level)

        // Act
        let action = sut.turnAction(for: actorEnemy!, with: actorSprite!)
        
        // Assert
        XCTAssertEqual(action, TurnAction.move(to: GridCell(x: 5, y: 4), direction: .north))
        XCTAssertNotNil(actorEnemy?.targetCell)
    }
    
    func testTurnAction_walk_reachedTarget() throws {
        // Arrange
        let player = entityFactory!.createPlayer(cell: GridCell(x: 0, y: 0))
        let actor = entityFactory!.createEnemy(enemyType: .ghost, cell: GridCell(x: 5, y: 5))
        let actorEnemy = entityManager!.enemyComponent(for: actor)
        actorEnemy?.targetCell = GridCell(x: 5, y: 5)
        let actorSprite = entityManager!.spriteComponent(for: actor)
        let level = MockGameLevel(player: player, actors: [actor])
        let sut = EnemyTurnActionSystem(entityManager: entityManager!, gameLevel: level)

        // Act
        let action = sut.turnAction(for: actorEnemy!, with: actorSprite!)
        
        // Assert
        XCTAssertEqual(action, TurnAction.move(to: GridCell(x: 5, y: 4), direction: .north))
        XCTAssertNotNil(actorEnemy?.targetCell)
        XCTAssertNotEqual(actorEnemy?.targetCell, GridCell(x: 5, y: 5))
    }
    
    func testTurnAction_walk_towardsTarget() throws {
        // Arrange
        let player = entityFactory!.createPlayer(cell: GridCell(x: 0, y: 0))
        let actor = entityFactory!.createEnemy(enemyType: .ghost, cell: GridCell(x: 5, y: 5))
        let actorEnemy = entityManager!.enemyComponent(for: actor)
        actorEnemy?.targetCell = GridCell(x: 5, y: 4)
        let actorSprite = entityManager!.spriteComponent(for: actor)
        let level = MockGameLevel(player: player, actors: [actor])
        let sut = EnemyTurnActionSystem(entityManager: entityManager!, gameLevel: level)

        // Act
        let action = sut.turnAction(for: actorEnemy!, with: actorSprite!)
        
        // Assert
        XCTAssertEqual(action, TurnAction.move(to: GridCell(x: 5, y: 4), direction: .north))
        XCTAssertNotNil(actorEnemy?.targetCell)
        XCTAssertEqual(actorEnemy?.targetCell, GridCell(x: 5, y: 4))
    }
}
