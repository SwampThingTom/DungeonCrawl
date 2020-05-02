//
//  DungeonGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol DungeonGenerating {
    func generate(size: GridSize) -> DungeonModel
}

class DungeonGenerator: DungeonGenerating {
    
    private let roomAttempts: Int
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private let roomGenerator: RoomGenerator
    
    private var map = DungeonMap()
    private var rooms = [RoomModel]()

    init(roomAttempts: Int = 5,
         randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.roomAttempts = roomAttempts
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        roomGenerator = RoomGenerator(randomNumberGenerator: self.randomNumberGenerator)
    }
    
    func generate(size: GridSize) -> DungeonModel {
        map = DungeonMap(size: size)
        generateRooms()
        generateMazes()
        return DungeonModel(map: map, rooms: rooms)
    }
    
    /// MARK: Tiles
    
    private func openTiles() -> [GridPoint] {
        var openTiles = [GridPoint]()
        for x in stride(from: 1, to: map.size.width, by: 2) {
            for y in stride(from: 1, to: map.size.height, by: 2) {
                let location = GridPoint(x: x, y: y)
                if map.cell(location: location) == .empty {
                    openTiles.append(location)
                }
            }
        }
        return openTiles
    }

    /// MARK: Rooms
    
    private func generateRooms() {
        rooms = roomGenerator.generate(gridSize: map.size, attempts: roomAttempts)
        addToTiles(rooms: rooms)
    }
    
    private func addToTiles(rooms: [RoomModel]) {
        for room in rooms {
            map.fillCells(at: room.bounds, with: .floor)
        }
    }
    
    /// MARK: Maze
    
    private enum Direction: CaseIterable {
        case north
        case east
        case south
        case west
        
        var offsets: (Int, Int) {
            switch self {
            case .north: return (0, -1)
            case .east: return (1, 0)
            case .south: return (0, 1)
            case .west: return (-1, 0)
            }
        }
    }
    
    private func generateMazes() {
        while true {
            let openTiles = self.openTiles()
            if openTiles.isEmpty {
                return
            }
            let startTile = openTiles.randomElement(using: &randomNumberGenerator)!
            generateMaze(at: startTile)
        }
    }
    
    private func generateMaze(at startTile: GridPoint) {
        carve(tile: startTile)
        var activeTiles = [startTile]
        repeat {
            let tileIndex = Int.random(in: 0 ..< activeTiles.count, using: &randomNumberGenerator)
            let tile = activeTiles[tileIndex]
            
            let possibleDirections = directionsWithEmptyNeighbors(from: tile)
            if possibleDirections.isEmpty {
                activeTiles.remove(at: tileIndex)
                continue
            }
            
            // TODO: prefer last direction
            let direction = possibleDirections.randomElement(using: &randomNumberGenerator)!
            let tilesToCarve = neighboringTiles(for: tile, heading: direction)
            carve(tile: tilesToCarve[0])
            carve(tile: tilesToCarve[1])
            activeTiles.append(tilesToCarve[1])
        } while !activeTiles.isEmpty
    }
    
    private func directionsWithEmptyNeighbors(from tile: GridPoint) -> [Direction] {
        var directionsWithEmptyNeighbors = [Direction]()
        for direction in Direction.allCases {
            let (x, y) = direction.offsets
            let neighborCell = GridPoint(x: tile.x + 2 * x, y: tile.y + 2 * y)
            if !map.isValid(location: neighborCell) {
                continue
            }
            if map.cell(location: neighborCell) != .empty {
                continue
            }
            directionsWithEmptyNeighbors.append(direction)
        }
        return directionsWithEmptyNeighbors
    }
    
    private func neighboringTiles(for tile: GridPoint, heading: Direction) -> [GridPoint] {
        let (x, y) = heading.offsets
        return [
            GridPoint(x: tile.x + x, y: tile.y + y),
            GridPoint(x: tile.x + 2 * x, y: tile.y + 2 * y)
        ]
    }
    
    private func carve(tile: GridPoint) {
        map.setCell(location: tile, tile: .floor)
    }
}
