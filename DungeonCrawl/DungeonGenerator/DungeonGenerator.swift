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
    
    let roomAttempts = 5
    
    var tiles = [[Tile]]()
    var rooms = [RoomModel]()
    
    func generate(size: CGSize) -> DungeonModel {
        tiles = emptyTiles(size: size)
        rooms = [RoomModel]()
        addRooms()
        return DungeonModel(size: size, tiles: tiles, rooms: rooms)
    }
    
    private func emptyTiles(size: CGSize) -> [[Tile]] {
        return [[Tile]](repeating: [Tile](repeating: .empty, count: Int(size.height)),
                        count: Int(size.width))
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
        let bounds = CGRect(x: 0, y: 0, width: 8, height: 6)
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
    
    private func fillTiles(at bounds: CGRect, with tile: Tile) {
        for x in Int(bounds.origin.x) ..< Int(bounds.origin.x) + Int(bounds.size.width) {
            let range = Int(bounds.origin.y) ..< Int(bounds.origin.y) + Int(bounds.size.height)
            tiles[x].replaceSubrange(range, with: repeatElement(tile, count: Int(bounds.size.height)))
        }
    }
}
