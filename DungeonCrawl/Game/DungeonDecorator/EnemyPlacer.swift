//
//  EnemyPlacer.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol EnemyPlacing {
    
    /// Adds random enemies to a dungeon.
    func placeEnemies(in dungeon: DungeonModel,
                      occupiedCells: OccupiedCells,
                      maxChallengeRating: Double) -> [EnemyModel]
}

class EnemyPlacer: EnemyPlacing {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private let enemyPicker: EnemyPicking

    init(enemyPicker: EnemyPicking? = nil,
         randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        self.enemyPicker = enemyPicker ?? EnemyPicker(randomNumberGenerator: randomNumberGenerator)
    }
    
    func placeEnemies(in dungeon: DungeonModel,
                      occupiedCells: OccupiedCells,
                      maxChallengeRating: Double) -> [EnemyModel] {
        
        guard dungeon.rooms.count > 0 else { return [] }
        
        var enemies = [EnemyModel]()
        var currentChallengeRating = 0.0
        var attemptsRemaining = dungeon.rooms.count
        
        while currentChallengeRating < maxChallengeRating && attemptsRemaining > 0 {
            attemptsRemaining -= 1
            
            let challenge = enemyPicker.random(dungeonLevel: 1)
            guard challenge.rating + currentChallengeRating <= maxChallengeRating else { continue }
            currentChallengeRating += challenge.rating
            
            let room = dungeon.rooms.randomElement(using: &randomNumberGenerator)!
            let cell = occupiedCells.findEmptyCell { room.bounds.randomCell(using: &randomNumberGenerator) }
            occupiedCells.occupy(cell: cell)
            
            let enemy = EnemyModel(enemyType: challenge.enemy, cell: cell)
            enemies.append(enemy)
        }
        return enemies
    }
}
