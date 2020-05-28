//
//  EnemyPicker.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

struct EnemyChallenge {
    let enemy: EnemyType
    let rating: Double
}

protocol EnemyPicking {
    
    /// Returns a random enemy challenge for the given one-based dungeon level.
    /// - Parameter dungeonLevel: One-based dungeon level.
    /// - Returns: An enemy type and its challenge rating.
    func random(dungeonLevel: Int) -> EnemyChallenge
}

class EnemyPicker: EnemyPicking {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator

    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }
    
    func random(dungeonLevel: Int) -> EnemyChallenge {
        let challenges = enemyChallenges(forDungeonLevel: dungeonLevel)
        return challenges.randomElement(using: &randomNumberGenerator)!
    }
}

/// Returns a list of enemy / challenge rating tuples appropriate for a particular dungeon level (one-based).
/// - Parameter level: One-based dungeon level
/// - Parameter challengeRatingsByLevel: Minimum and maximum ratings for each level.
/// - Parameter enemyChallenges: Enemy challenges to filter.
/// - Returns: Enemy challenges between the minimum and maximum rating for the level.
func enemyChallenges(forDungeonLevel level: Int,
                     challengeRatingsByLevel: [(min: Double, max: Double)] = challengeRatingsByLevel,
                     from enemyChallenges: [EnemyChallenge] = enemyChallenges) -> [EnemyChallenge] {
    
    assert(level > 0, "level for enemy challenges is one-based")
    assert(level <= challengeRatingsByLevel.count, "min and max ratings are not defined for level \(level)")
    
    let (minCR, maxCR) = challengeRatingsByLevel[level-1]
    return enemyChallenges.filter { challenge in
        return challenge.rating >= minCR && challenge.rating <= maxCR
    }
}

let challengeRatingsByLevel: [(min: Double, max: Double)] = [
    (0.0, 0.125),
    (0.0, 0.25),
    (0.0, 0.5)
]

let enemyChallenges: [EnemyChallenge] = [
    
    // CR 1/8
    EnemyChallenge(enemy: .jellyCube, rating: 0.125),
    
    // CR 1/4
    EnemyChallenge(enemy: .giantBat, rating: 0.25),
    EnemyChallenge(enemy: .skeleton, rating: 0.25),
    
    // CR 1/2
    EnemyChallenge(enemy: .shadow, rating: 0.5),
    
    // CR 1
    EnemyChallenge(enemy: .giantSpider, rating: 1),
    
    // CR 2
    EnemyChallenge(enemy: .ghast, rating: 2)
]
