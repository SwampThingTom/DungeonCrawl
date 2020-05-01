//
//  DungeonModel.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

struct DungeonModel {
    let map: DungeonMap
    let rooms: [RoomModel]
}

struct DungeonMap: GridMap {
    private let tiles: [[Tile]]
    
    var size: GridSize {
        guard tiles.count != 0 else {
            return GridSize(width: 0, height: 0)
        }
        return GridSize(width: tiles.count, height: tiles[0].count)
    }
    
    init(tiles: [[Tile]] = [[Tile]]()) {
        self.tiles = tiles
    }
    
    func cell(location: GridPoint) -> Tile? {
        guard !isEmpty(location: location) else {
            return nil
        }
        return tiles[location.x][location.y]
    }
    
    func isEmpty(location: GridPoint) -> Bool {
        guard 0 ..< size.width ~= location.x && 0 ..< size.height ~= location.y else {
            return false
        }
        return tiles[location.x][location.y] == .empty
    }
}

struct RoomModel {
    let bounds: GridRect
}
