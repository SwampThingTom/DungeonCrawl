//
//  DungeonDecorator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

class DungeonDecorator {
    
    let dungeon: DungeonModel
    
    init(dungeon: DungeonModel) {
        self.dungeon = dungeon
    }
    
    func playerStartCell() -> GridCell? {
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
