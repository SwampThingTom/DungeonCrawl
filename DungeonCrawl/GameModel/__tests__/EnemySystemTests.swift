//
//  EnemySystemTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class EnemySystemTests: XCTestCase {

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
    
    func testTurnAction_playerInRange() throws {
        // Arrange
        let player = entityFactory!.createPlayer(cell: GridCell(x: 4, y: 5))
        let actor = entityFactory!.createEnemy(enemyType: .ghost, cell: GridCell(x: 5, y: 5))
        let actorSprite = entityManager!.spriteComponent(for: actor)
        let level = MockGameLevel(player: player, actors: [actor])
        let sut = EnemySystem(entityManager: entityManager!, gameLevel: level)

        // Act
        let action = sut.turnAction(for: actorSprite!)
        
        // Assert
        XCTAssertEqual(action, TurnAction.attack(direction: .west))
    }
    
    func testTurnAction_noAttackTargets() throws {
        // Arrange
        let player = entityFactory!.createPlayer(cell: GridCell(x: 0, y: 0))
        let actor = entityFactory!.createEnemy(enemyType: .ghost, cell: GridCell(x: 5, y: 5))
        let actorSprite = entityManager!.spriteComponent(for: actor)
        let level = MockGameLevel(player: player, actors: [actor])
        let sut = EnemySystem(entityManager: entityManager!, gameLevel: level)

        // Act
        let action = sut.turnAction(for: actorSprite!)
        
        // Assert
        XCTAssertEqual(action, TurnAction.nothing)
    }
}
