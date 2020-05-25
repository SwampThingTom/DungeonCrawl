//
//  DungeonDecorator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol DungeonDecorating {
    func decorate(dungeon: DungeonModel) -> DungeonDecorations
}

class DungeonDecorator: DungeonDecorating {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private let chance: ChanceDetermining

    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator(),
         chance: ChanceDetermining? = nil) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        self.chance = chance ?? Chance(randomNumberGenerator: randomNumberGenerator)
    }
    
    func decorate(dungeon: DungeonModel) -> DungeonDecorations {
        guard let playerStartCell = playerStartCell(in: dungeon) else {
            fatalError("Unable to place player in dungeon")
        }
        let treasure = placeTreasure(in: dungeon)
        let enemies = spawnEnemies(in: dungeon)
        return DungeonDecorations(playerStartCell: playerStartCell, enemies: enemies, treasure: treasure)
    }

    private func playerStartCell(in dungeon: DungeonModel) -> GridCell? {
        for x in 0 ..< dungeon.map.size.width {
            for y in 0 ..< dungeon.map.size.height {
                let cell = GridCell(x: x, y: y)
                if dungeon.map.tile(at: cell) == .floor {
                    return cell
                }
            }
        }
        return nil
    }
    
    private func placeTreasure(in dungeon: DungeonModel) -> [Treasure] {
        let treasure: [Treasure] = dungeon.rooms.compactMap { room in
            guard chance.one(in: 2) else { return nil }
            let gold = Int.random(in: 1...50)
            let cell = room.bounds.randomWallCell(using: &randomNumberGenerator)
            return Treasure(gold: gold, cell: cell)
        }
        return treasure
    }
    
    private func spawnEnemies(in dungeon: DungeonModel) -> [EnemyModel] {
        guard dungeon.rooms.count > 0 else {
            return []
        }
        let room = dungeon.rooms.randomElement(using: &randomNumberGenerator)!
        let cell = room.bounds.randomCell(using: &randomNumberGenerator)
        let enemy = EnemyModel(enemyType: .ghost, cell: cell)
        return [enemy]
    }
}

extension GridRect {
    
    func randomCell(using randomNumberGenerator: inout AnyRandomNumberGenerator) -> GridCell {
        let x = gridXRange.randomElement(using: &randomNumberGenerator)!
        let y = gridYRange.randomElement(using: &randomNumberGenerator)!
        return GridCell(x: x, y: y)
    }
    
    func randomWallCell(using randomNumberGenerator: inout AnyRandomNumberGenerator) -> GridCell {
        let wall = Direction.allCases.randomElement(using: &randomNumberGenerator)!
        switch wall {
        case .north:
            let x = gridXRange.randomElement(using: &randomNumberGenerator)!
            return GridCell(x: x, y: gridYRange.min()!)
        case .south:
            let x = gridXRange.randomElement(using: &randomNumberGenerator)!
            return GridCell(x: x, y: gridYRange.max()!)
        case .west:
            let y = gridYRange.randomElement(using: &randomNumberGenerator)!
            return GridCell(x: gridXRange.min()!, y: y)
        case .east:
            let y = gridYRange.randomElement(using: &randomNumberGenerator)!
            return GridCell(x: gridXRange.max()!, y: y)
        }
    }
}
