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
        let level = MockGameLevel(player: entityFactory.createPlayer(cell: GridCell(x: 0, y: 0)), actors: [])
        
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
        let level = MockGameLevel(player: entityFactory.createPlayer(cell: GridCell(x: 0, y: 0)),
                                  actors: [entityFactory.createEnemy(enemyType: .ghost, cell: GridCell(x: 5, y: 5))])
        
        // Act
        let isComplete = sut.isComplete(gameLevel: level)
        
        // Assert
        XCTAssertFalse(isComplete)
    }
}
