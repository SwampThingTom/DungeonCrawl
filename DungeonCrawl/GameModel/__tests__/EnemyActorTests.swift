//
//  EnemyActorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class EnemyActorTests: XCTestCase {

    func testTurnAction_playerInRange() throws {
        // Arrange
        let player = PlayerActor(name: "Player", displayName: "Player", cell: GridCell(x: 4, y: 5))
        let enemy = EnemyModel(enemyType: .ghost, cell: GridCell(x: 5, y: 5))
        let sut = EnemyActor(name: "Enemy", model: enemy)
        let level = MockGameLevel(player: player, actors: [sut])

        // Act
        let action = sut.turnAction(level: level)
        
        // Assert
        XCTAssertEqual(action, TurnAction.attack(direction: .west))
    }
    
    func testTurnAction_noAttackTargets() throws {
        // Arrange
        let player = PlayerActor(name: "Player", displayName: "Player", cell: GridCell(x: 0, y: 0))
        let enemy = EnemyModel(enemyType: .ghost, cell: GridCell(x: 5, y: 5))
        let sut = EnemyActor(name: "Enemy", model: enemy)
        let level = MockGameLevel(player: player, actors: [sut])

        // Act
        let action = sut.turnAction(level: level)
        
        // Assert
        XCTAssertEqual(action, TurnAction.nothing)
    }
}
