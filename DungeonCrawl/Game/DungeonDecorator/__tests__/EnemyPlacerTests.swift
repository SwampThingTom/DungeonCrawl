//
//  EnemyPlacerTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class EnemyPlacerTests: XCTestCase {

    func testPlaceEnemies_noRooms() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: [])
        let occupiedCells = OccupiedCells()
        let enemyPicker = MockEnemyPicker()
        let sut = EnemyPlacer(enemyPicker: enemyPicker)
        
        // Act
        let enemies = sut.placeEnemies(in: dungeon, occupiedCells: occupiedCells, maxChallengeRating: 1)
        
        // Assert
        XCTAssertEqual(enemies.count, 0)
        XCTAssert(occupiedCells.isEmpty)
    }
    
    func testPlaceEnemies_zeroChallengeRating() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let occupiedCells = OccupiedCells()
        let enemyPicker = MockEnemyPicker()
        let sut = EnemyPlacer(enemyPicker: enemyPicker)
        
        // Act
        let enemies = sut.placeEnemies(in: dungeon, occupiedCells: occupiedCells, maxChallengeRating: 0)
        
        // Assert
        XCTAssertEqual(enemies.count, 0)
        XCTAssert(occupiedCells.isEmpty)
    }
    
    func testPlaceEnemies_enemiesAboveMaxChallengeRating() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let occupiedCells = OccupiedCells()
        let enemyPicker = MockEnemyPicker()
        enemyPicker.mockEnemies = [
            EnemyChallenge(enemy: .ghast, rating: 2),
            EnemyChallenge(enemy: .ghast, rating: 2),
            EnemyChallenge(enemy: .ghast, rating: 2),
        ]
        let sut = EnemyPlacer(enemyPicker: enemyPicker)
        
        // Act
        let enemies = sut.placeEnemies(in: dungeon, occupiedCells: occupiedCells, maxChallengeRating: 0.25)
        
        // Assert
        XCTAssertEqual(enemies.count, 0)
        XCTAssert(occupiedCells.isEmpty)
    }
    
    func testPlaceEnemies_lessThanMaxChallengeRating() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let occupiedCells = OccupiedCells()
        let enemyPicker = MockEnemyPicker()
        enemyPicker.mockEnemies = [
            EnemyChallenge(enemy: .ghast, rating: 0.25),
            EnemyChallenge(enemy: .ghast, rating: 0.5),
            EnemyChallenge(enemy: .ghast, rating: 0.5),
        ]
        let sut = EnemyPlacer(enemyPicker: enemyPicker)
        
        // Act
        let enemies = sut.placeEnemies(in: dungeon, occupiedCells: occupiedCells, maxChallengeRating: 1)
        
        // Assert
        XCTAssertEqual(enemies.count, 2)
        XCTAssertEqual(occupiedCells.count, 2)
    }
    
    func testPlaceEnemies_equalToMaxChallengeRating() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let occupiedCells = OccupiedCells()
        let enemyPicker = MockEnemyPicker()
        enemyPicker.mockEnemies = [
            EnemyChallenge(enemy: .ghast, rating: 0.5),
            EnemyChallenge(enemy: .ghast, rating: 0.5),
            EnemyChallenge(enemy: .ghast, rating: 0.25),
        ]
        let sut = EnemyPlacer(enemyPicker: enemyPicker)
        
        // Act
        let enemies = sut.placeEnemies(in: dungeon, occupiedCells: occupiedCells, maxChallengeRating: 1)
        
        // Assert
        XCTAssertEqual(enemies.count, 2)
        XCTAssertEqual(occupiedCells.count, 2)
    }
}

class MockEnemyPicker: EnemyPicking {
    
    private var nextEnemy: Int = 0
    
    var mockEnemies = [EnemyChallenge]()
    
    func random(dungeonLevel: Int) -> EnemyChallenge {
        let enemy = mockEnemies[nextEnemy]
        nextEnemy += 1
        return enemy
    }
}
