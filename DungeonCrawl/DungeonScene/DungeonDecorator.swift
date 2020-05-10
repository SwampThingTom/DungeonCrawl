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
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }
    
    func decorate(dungeon: DungeonModel) -> DungeonDecorations {
        guard let playerStartCell = playerStartCell(in: dungeon) else {
            fatalError("Unable to place player in dungeon")
        }
        let enemies = spawnEnemies(in: dungeon)
        return DungeonDecorations(playerStartCell: playerStartCell, enemies: enemies)
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
    
    private func spawnEnemies(in dungeon: DungeonModel) -> [EnemyModel] {
        guard dungeon.rooms.count > 0 else {
            return []
        }
        let room = dungeon.rooms.randomElement(using: &randomNumberGenerator)!
        let cell = room.bounds.randomCell(using: &randomNumberGenerator)
        let enemy = EnemyModel(spriteName: "Ghost", cell: cell)
        return [enemy]
    }
}

extension GridRect {
    
    func randomCell(using randomNumberGenerator: inout AnyRandomNumberGenerator) -> GridCell {
        let x = gridXRange.randomElement(using: &randomNumberGenerator)!
        let y = gridYRange.randomElement(using: &randomNumberGenerator)!
        return GridCell(x: x, y: y)
    }
}
