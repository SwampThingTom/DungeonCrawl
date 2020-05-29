//
//  TreasurePlacer.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol TreasurePlacing {
    
    /// Adds random treasure to a dungeon.
    func placeTreasure(in dungeon: DungeonModel, occupiedCells: OccupiedCells) -> [ItemModel]
}

class TreasurePlacer: TreasurePlacing {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private let chance: ChanceDetermining
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator(),
         chance: ChanceDetermining? = nil) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        self.chance = chance ?? Chance(randomNumberGenerator: randomNumberGenerator)
    }
    
    func placeTreasure(in dungeon: DungeonModel, occupiedCells: OccupiedCells) -> [ItemModel] {
        let treasure: [ItemModel] = dungeon.rooms.compactMap { room in
            guard chance.one(in: 3) else { return nil }
            let cell = room.bounds.randomWallCell(using: &randomNumberGenerator)
            guard !occupiedCells.isOccupied(cell: cell) else { return nil }
            occupiedCells.occupy(cell: cell)
            let gold = Dice(die: D10(), numberOfDice: 5).roll()
            let item = createTreasure(worth: gold)
            return ItemModel(item: item, cell: cell)
        }
        return treasure
    }
}
