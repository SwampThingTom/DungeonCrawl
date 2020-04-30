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
        generateMazes()
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
    
    private func openTiles() -> [TilePoint] {
        var openTiles = [TilePoint]()
        for x in stride(from: 1, to: self.size.width, by: 2) {
            for y in stride(from: 1, to: self.size.height, by: 2) {
                if tiles[x][y] == .empty {
                    openTiles.append(TilePoint(x: x, y: y))
                }
            }
        }
        return openTiles
    }

    private func randomRect(size: TileSize) -> TileRect {
        // ensure origins are at odd locations
        let maxX: Int = (self.size.width - size.width) / 2
        let maxY: Int = (self.size.height - size.height) / 2
        let x = Int.random(in: 0 ... maxX, using: &randomNumberGenerator) * 2 + 1
        let y = Int.random(in: 0 ... maxY, using: &randomNumberGenerator) * 2 + 1
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
    
    private func generateMaze(at startTile: TilePoint) {
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
    
    private func directionsWithEmptyNeighbors(from tile: TilePoint) -> [Direction] {
        var directionsWithEmptyNeighbors = [Direction]()
        for direction in Direction.allCases {
            let (x, y) = direction.offsets
            let neighborTile = TilePoint(x: tile.x + 2 * x, y: tile.y + 2 * y)
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
    
    private func neighboringTiles(for tile: TilePoint, heading: Direction) -> [TilePoint] {
        let (x, y) = heading.offsets
        return [
            TilePoint(x: tile.x + x, y: tile.y + y),
            TilePoint(x: tile.x + 2 * x, y: tile.y + 2 * y)
        ]
    }
    
    private func carve(tile: TilePoint) {
        tiles[tile.x][tile.y] = .floor
    }
}
