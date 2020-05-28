//
//  EnemyPickerTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class EnemyPickerTests: XCTestCase {

    func testEnemyChallenges_minLevel() throws {
        // Arrange
        let challengeRatings = [
            (min: 0.0, max: 0.125),
            (min: 0.125, max: 0.5),
            (min: 0.25, max: 1)
        ]
        let enemyChallenges = [
            EnemyChallenge(enemy: .jellyCube, rating: 0.125),
            EnemyChallenge(enemy: .giantBat, rating: 0.25),
            EnemyChallenge(enemy: .skeleton, rating: 0.25),
            EnemyChallenge(enemy: .shadow, rating: 0.5),
            EnemyChallenge(enemy: .giantSpider, rating: 1),
            EnemyChallenge(enemy: .ghast, rating: 2)
        ]
        
        // Act
        let filteredChallenges = DungeonCrawl.enemyChallenges(forDungeonLevel: 1,
                                                              challengeRatingsByLevel: challengeRatings,
                                                              from: enemyChallenges)
        
        // Assert
        XCTAssertEqual(filteredChallenges.count, 1)
        XCTAssert(filteredChallenges.contains { $0.enemy == .jellyCube })
    }
    
    func testEnemyChallenges_maxLevel() throws {
        // Arrange
        let challengeRatings = [
            (min: 0.0, max: 0.125),
            (min: 0.125, max: 0.5),
            (min: 0.25, max: 1)
        ]
        let enemyChallenges = [
            EnemyChallenge(enemy: .jellyCube, rating: 0.125),
            EnemyChallenge(enemy: .giantBat, rating: 0.25),
            EnemyChallenge(enemy: .skeleton, rating: 0.25),
            EnemyChallenge(enemy: .shadow, rating: 0.5),
            EnemyChallenge(enemy: .giantSpider, rating: 1),
            EnemyChallenge(enemy: .ghast, rating: 2)
        ]
        
        // Act
        let filteredChallenges = DungeonCrawl.enemyChallenges(forDungeonLevel: 3,
                                                              challengeRatingsByLevel: challengeRatings,
                                                              from: enemyChallenges)
        
        // Assert
        XCTAssertEqual(filteredChallenges.count, 4)
        XCTAssert(filteredChallenges.contains { $0.enemy == .giantBat })
        XCTAssert(filteredChallenges.contains { $0.enemy == .skeleton })
        XCTAssert(filteredChallenges.contains { $0.enemy == .shadow })
        XCTAssert(filteredChallenges.contains { $0.enemy == .giantSpider })
    }
}
