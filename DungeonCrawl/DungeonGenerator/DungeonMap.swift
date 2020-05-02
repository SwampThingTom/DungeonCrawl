//
//  DungeonMap.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

struct DungeonMap: GridMap {
    private var tiles: [[Tile]]
    
    var size: GridSize {
        guard tiles.count > 0 && tiles[0].count > 0 else {
            return GridSize(width: 0, height: 0)
        }
        return GridSize(width: tiles.count, height: tiles[0].count)
    }
    
    init(tiles: [[Tile]] = [[Tile]]()) {
        self.tiles = tiles
    }
    
    init(size: GridSize) {
        self.init(tiles: DungeonMap.emptyCells(size: size))
    }
    
    func isValid(location: GridPoint) -> Bool {
        return 0 ..< size.width ~= location.x && 0 ..< size.height ~= location.y
    }
    
    func cell(location: GridPoint) -> Tile? {
        guard isValid(location: location) else {
            return nil
        }
        return tiles[location.x][location.y]
    }

    private static func emptyCells(size: GridSize) -> [[Tile]] {
        return [[Tile]](repeating: [Tile](repeating: .empty, count: size.height),
                        count: size.width)
    }
}
