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
    
    func testQuest_killAllEnemies_isComplete() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let sut = QuestKillAllEnemies()
        let player = entityFactory.createPlayer(cell: GridCell(x: 0, y: 0))
        let level = mockGameLevel(entityManager: entityManager, player: player)
        
        // Act
        let isComplete = sut.isComplete(gameLevel: level)
        
        // Assert
        XCTAssertTrue(isComplete)
    }
    
    func test_killAllEnemies_isNotComplete() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let sut = QuestKillAllEnemies()
        let player = entityFactory.createPlayer(cell: GridCell(x: 0, y: 0))
        entityFactory.createEnemy(enemyType: .ghast, cell: GridCell(x: 5, y: 5))
        let level = mockGameLevel(entityManager: entityManager, player: player)
        
        // Act
        let isComplete = sut.isComplete(gameLevel: level)
        
        // Assert
        XCTAssertFalse(isComplete)
    }
    
    func testQuest_findItem_isComplete() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        
        let questItem = ItemBuilder.init(name: "Treasure of Mot").withQuestItem().build()
        let questItemEntity = entityManager.createEntity()
        let questItemComponent = ItemComponent.init(item: questItem)
        questItemEntity.add(component: questItemComponent)
        
        let sut = QuestFindItem(item: questItem)
        let player = entityFactory.createPlayer(cell: GridCell(x: 0, y: 0))
        player.inventoryComponent()?.add(item: questItemComponent)
        let level = mockGameLevel(entityManager: entityManager, player: player)
        
        // Act
        let isComplete = sut.isComplete(gameLevel: level)
        
        // Assert
        XCTAssertTrue(isComplete)
    }
    
    func testQuest_findItem_isNotComplete() throws {
        // Arrange
        let entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        
        let questItem = ItemBuilder.init(name: "Treasure of Mot").withQuestItem().build()
        let questItemEntity = entityManager.createEntity()
        let questItemComponent = ItemComponent.init(item: questItem)
        questItemEntity.add(component: questItemComponent)
        
        let sut = QuestFindItem(item: questItem)
        let player = entityFactory.createPlayer(cell: GridCell(x: 0, y: 0))
        let level = mockGameLevel(entityManager: entityManager, player: player)
        
        // Act
        let isComplete = sut.isComplete(gameLevel: level)
        
        // Assert
        XCTAssertFalse(isComplete)
    }
}
