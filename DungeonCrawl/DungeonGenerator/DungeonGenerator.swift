//
//  DungeonGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import CoreGraphics
import Foundation

protocol DungeonGenerating {
    func generate(size: CGSize) -> DungeonModel
}

class DungeonGenerator: DungeonGenerating {
    func generate(size: CGSize) -> DungeonModel {
        let tiles = emptyTiles(size: size)
        let rooms = addRooms()
        return DungeonModel(size: size, tiles: tiles, rooms: rooms)
    }
    
    private func emptyTiles(size: CGSize) -> [[Tile]] {
        return [[Tile]](repeating: [Tile](repeating: .empty, count: Int(size.height)),
                        count: Int(size.width))
    }
    
    private func addRooms() -> [RoomModel] {
        return [RoomModel]()
    }
}
