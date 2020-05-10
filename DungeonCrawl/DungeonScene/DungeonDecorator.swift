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

struct DungeonDecorator: DungeonDecorating {
    
    func decorate(dungeon: DungeonModel) -> DungeonDecorations {
        guard let playerStartCell = playerStartCell(in: dungeon) else {
            fatalError("Unable to place player in dungeon")
        }
        return DungeonDecorations(playerStartCell: playerStartCell, enemies: [])
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
}
