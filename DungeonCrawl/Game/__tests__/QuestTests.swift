//
//  QuestTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/18/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class QuestTests: XCTestCase {
    
    func testIsComplete() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let sut = Quest()
        let player = entityFactory.createPlayer(cell: GridCell(x: 0, y: 0))
        let level = mockGameLevel(entityManager: entityManager, player: player)
        
        // Act
        let isComplete = sut.isComplete(gameLevel: level)
        
        // Assert
        XCTAssertTrue(isComplete)
    }
    
    func testIsNotComplete() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let sut = Quest()
        let player = entityFactory.createPlayer(cell: GridCell(x: 0, y: 0))
        entityFactory.createEnemy(enemyType: .ghast, cell: GridCell(x: 5, y: 5))
        let level = mockGameLevel(entityManager: entityManager, player: player)
        
        // Act
        let isComplete = sut.isComplete(gameLevel: level)
        
        // Assert
        XCTAssertFalse(isComplete)
    }
}
