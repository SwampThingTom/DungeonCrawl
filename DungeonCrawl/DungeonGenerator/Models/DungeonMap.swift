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
        return GridSize(width: tiles[0].count, height: tiles.count)
    }
    
    init(tiles: [[Tile]] = [[Tile]]()) {
        self.tiles = tiles
        assert(size.height == 0 || (size.width % 2 == 1 && size.height % 2 == 1), "Width and height must be odd numbers.")
    }
    
    init(size: GridSize) {
        self.init(tiles: DungeonMap.wallCells(size: size))
    }
    
    func copy() -> DungeonMap {
        return DungeonMap(tiles: tiles)
    }
    
    func isValid(location: GridPoint) -> Bool {
        return 0 ..< size.width ~= location.x && 0 ..< size.height ~= location.y
    }
    
    func cell(location: GridPoint) -> Tile? {
        guard isValid(location: location) else {
            return nil
        }
        return tiles[location.y][location.x]
    }
    
    private static func wallCells(size: GridSize) -> [[Tile]] {
        return [[Tile]](repeating: [Tile](repeating: .wall, count: size.width),
                        count: size.height)
    }
}

extension DungeonMap: MutableGridMap {
    
    mutating func setCell(location: GridPoint, tile: Tile) {
        tiles[location.y][location.x] = tile
    }
    
    mutating func fillCells(at bounds: GridRect, with tile: Tile) {
        let filledTiles = repeatElement(tile, count: bounds.size.width)
        for y in bounds.gridYRange {
            tiles[y].replaceSubrange(bounds.gridXRange, with: filledTiles)
        }
    }
}
