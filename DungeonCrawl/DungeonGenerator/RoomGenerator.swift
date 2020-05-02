//
//  RoomGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/30/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol RoomGenerating {
    func generate(gridSize: GridSize, attempts: Int) -> [RoomModel]
}

class RoomGenerator: RoomGenerating {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    // Rooms should have odd widths and heights to allow for
    // empty spaces between rooms and corridors.
    let roomSize = GridSize(width: 7, height: 5)
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }
    
    func generate(gridSize: GridSize, attempts: Int) -> [RoomModel] {
        // Leave the first and last column and row empty
        let useableGridSize = GridSize(width: gridSize.width - 2, height: gridSize.height - 2)
        guard useableGridSize.width >= roomSize.width && useableGridSize.height >= roomSize.height else {
            return []
        }
        
        var rooms = [RoomModel]()
        for _ in 0 ..< attempts {
            let room = createRoom(gridSize: useableGridSize)
            if !overlaps(room: room, existing: rooms) {
                rooms.append(room)
            }
        }
        return rooms
    }
    
    private func createRoom(gridSize: GridSize) -> RoomModel {
        let bounds = randomRect(size: roomSize, inGridSize: gridSize)
        return RoomModel(bounds: bounds)
    }
    
    private func overlaps(room: RoomModel, existing rooms: [RoomModel]) -> Bool {
        for existingRoom in rooms {
            if room.bounds.intersects(existingRoom.bounds) {
                return true
            }
        }
        return false
    }
    
    private func randomRect(size: GridSize, inGridSize gridSize: GridSize) -> GridRect {
        // ensure origins are at odd locations
        let maxX: Int = (gridSize.width - size.width) / 2
        let maxY: Int = (gridSize.height - size.height) / 2
        let x = Int.random(in: 0 ... maxX, using: &randomNumberGenerator) * 2 + 1
        let y = Int.random(in: 0 ... maxY, using: &randomNumberGenerator) * 2 + 1
        return GridRect(x: x, y: y, width: size.width, height: size.height)
    }
    
}
