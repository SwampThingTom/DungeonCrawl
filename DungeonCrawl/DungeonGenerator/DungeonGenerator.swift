//
//  DungeonGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol DungeonGenerating {
    func generate(size: TileSize) -> DungeonModel
}

class DungeonGenerator: DungeonGenerating {
    
    let roomAttempts = 5
    
    var tiles = [[Tile]]()
    var rooms = [RoomModel]()
    
    func generate(size: TileSize) -> DungeonModel {
        tiles = emptyTiles(size: size)
        rooms = [RoomModel]()
        addRooms()
        return DungeonModel(size: size, tiles: tiles, rooms: rooms)
    }
    
    private func emptyTiles(size: TileSize) -> [[Tile]] {
        return [[Tile]](repeating: [Tile](repeating: .empty, count: size.height),
                        count: size.width)
    }
    
    private func addRooms() {
        for _ in 0 ..< roomAttempts {
            let room = createRoom()
            if !overlaps(room: room) {
                add(room: room)
            }
        }
    }
    
    private func createRoom() -> RoomModel {
        let bounds = TileRect(x: 0, y: 0, width: 8, height: 6)
        return RoomModel(bounds: bounds)
    }
    
    private func overlaps(room: RoomModel) -> Bool {
        for existingRoom in rooms {
            if room.bounds.intersects(existingRoom.bounds) {
                return true
            }
        }
        return false
    }
    
    private func add(room: RoomModel) {
        rooms.append(room)
        fillTiles(at: room.bounds, with: .floor)
    }
    
    private func fillTiles(at bounds: TileRect, with tile: Tile) {
        let filledTiles = repeatElement(tile, count: bounds.size.height)
        for x in bounds.tileXRange {
            tiles[x].replaceSubrange(bounds.tileYRange, with: filledTiles)
        }
    }
}
