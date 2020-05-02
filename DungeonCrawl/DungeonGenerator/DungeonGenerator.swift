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
    
    private var tiles = [[Tile]]()
    private var rooms = [RoomModel]()
    
    private var size: GridSize {
        guard tiles.count > 0 else { return GridSize(width: 0, height: 0) }
        return GridSize(width: tiles.count, height: tiles[0].count)
    }

    init(roomAttempts: Int = 5,
         randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.roomAttempts = roomAttempts
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        roomGenerator = RoomGenerator(randomNumberGenerator: self.randomNumberGenerator)
    }
    
    func generate(size: GridSize) -> DungeonModel {
        tiles = emptyTiles(size: size)
        generateRooms()
        generateMazes()
        return DungeonModel(map: DungeonMap(tiles: tiles), rooms: rooms)
    }
    
    /// MARK: Tiles
    
    private func emptyTiles(size: GridSize) -> [[Tile]] {
        return [[Tile]](repeating: [Tile](repeating: .empty, count: size.height),
                        count: size.width)
    }
    
    private func fillTiles(at bounds: GridRect, with tile: Tile) {
        let filledTiles = repeatElement(tile, count: bounds.size.height)
        for x in bounds.gridXRange {
            tiles[x].replaceSubrange(bounds.gridYRange, with: filledTiles)
        }
    }
    
    private func openTiles() -> [GridPoint] {
        var openTiles = [GridPoint]()
        for x in stride(from: 1, to: self.size.width, by: 2) {
            for y in stride(from: 1, to: self.size.height, by: 2) {
                if tiles[x][y] == .empty {
                    openTiles.append(GridPoint(x: x, y: y))
                }
            }
        }
        return openTiles
    }

    /// MARK: Rooms
    
    private func generateRooms() {
        rooms = roomGenerator.generate(gridSize: size, attempts: roomAttempts)
        addToTiles(rooms: rooms)
    }
    
    private func addToTiles(rooms: [RoomModel]) {
        for room in rooms {
            fillTiles(at: room.bounds, with: .floor)
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
            let neighborTile = GridPoint(x: tile.x + 2 * x, y: tile.y + 2 * y)
            let isNeighborOnMap = 0 ..< tiles.count ~= neighborTile.x && 0 ..< tiles[0].count ~= neighborTile.y
            if !isNeighborOnMap {
                continue
            }
            if tiles[neighborTile.x][neighborTile.y] != .empty {
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
        tiles[tile.x][tile.y] = .floor
    }
}
