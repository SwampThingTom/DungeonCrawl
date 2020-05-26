//
//  EntityFactoryTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/26/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class EntityFactoryTests: XCTestCase {

    func testCreatePlayer() throws {
        // Arrange
        let entityManager = EntityManager()
        let sut = EntityFactory(entityManager: entityManager)
        
        // Act
        let player = sut.createPlayer(cell: GridCell(x: 0, y: 0))
        
        // Assert
        XCTAssertNotNil(player.spriteComponent())
        XCTAssertNotNil(player.combatComponent())
        XCTAssertNotNil(player.inventoryComponent())
        player.inventoryComponent()?.items.forEach {
            XCTAssertNotNil($0.entity)
            XCTAssertNil($0.entity?.spriteComponent())
        }
    }
}
