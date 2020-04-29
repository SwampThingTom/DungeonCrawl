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
    
    private let roomAttempts: Int
    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    var tiles = [[Tile]]()
    var rooms = [RoomModel]()
    
    var size: TileSize {
        guard tiles.count > 0 else { return TileSize(width: 0, height: 0) }
        return TileSize(width: tiles.count, height: tiles[0].count)
    }

    init(roomAttempts: Int = 5,
         randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.roomAttempts = roomAttempts
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }
    
    func generate(size: TileSize) -> DungeonModel {
        tiles = emptyTiles(size: size)
        rooms = [RoomModel]()
        addRooms()
        return DungeonModel(size: size, tiles: tiles, rooms: rooms)
    }
    
    /// MARK: Tiles
    
    private func emptyTiles(size: TileSize) -> [[Tile]] {
        return [[Tile]](repeating: [Tile](repeating: .empty, count: size.height),
                        count: size.width)
    }
    
    private func fillTiles(at bounds: TileRect, with tile: Tile) {
        let filledTiles = repeatElement(tile, count: bounds.size.height)
        for x in bounds.tileXRange {
            tiles[x].replaceSubrange(bounds.tileYRange, with: filledTiles)
        }
    }

    private func randomRect(size: TileSize) -> TileRect {
        let maxWidth: Int = self.size.width - size.width
        let maxHeight: Int = self.size.height - size.height
        let x = Int.random(in: 0 ... maxWidth, using: &randomNumberGenerator)
        let y = Int.random(in: 0 ... maxHeight, using: &randomNumberGenerator)
        return TileRect(x: x, y: y, width: size.width, height: size.height)
    }

    /// MARK: Rooms
    
    private func addRooms() {
        for _ in 0 ..< roomAttempts {
            let room = createRoom()
            if !overlaps(room: room) {
                add(room: room)
            }
        }
    }
    
    private func createRoom() -> RoomModel {
        let bounds = randomRect(size: TileSize(width: 8, height: 6))
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
}
