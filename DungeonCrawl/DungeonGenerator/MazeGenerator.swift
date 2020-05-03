//
//  MazeGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol MazeGenerating {
    func generate(map: inout MutableGridMap)
}

class MazeGenerator: MazeGenerating {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }
    
    func generate(map: inout MutableGridMap) {
        while true {
            let openTiles = openMapTiles(map)
            if openTiles.isEmpty {
                return
            }
            let startTile = openTiles.randomElement(using: &randomNumberGenerator)!
            generateMaze(at: startTile, in: &map)
        }
    }
    
    private func openMapTiles(_ map: GridMap) -> [GridPoint] {
        var openTiles = [GridPoint]()
        for x in stride(from: 1, to: map.size.width, by: 2) {
            for y in stride(from: 1, to: map.size.height - 1, by: 2) {
                let location = GridPoint(x: x, y: y)
                if map.cell(location: location) == .empty {
                    openTiles.append(location)
                }
            }
        }
        return openTiles
    }
    
    private func generateMaze(at startTile: GridPoint, in map: inout MutableGridMap) {
        carve(tile: startTile, in: &map)
        var activeTiles = [startTile]
        repeat {
            let tileIndex = Int.random(in: 0 ..< activeTiles.count, using: &randomNumberGenerator)
            let tile = activeTiles[tileIndex]
            
            let possibleDirections = directionsWithEmptyNeighbors(from: tile, in: map)
            if possibleDirections.isEmpty {
                activeTiles.remove(at: tileIndex)
                continue
            }
            
            // TODO: prefer last direction
            let direction = possibleDirections.randomElement(using: &randomNumberGenerator)!
            let tilesToCarve = neighboringTiles(for: tile, heading: direction)
            carve(tile: tilesToCarve[0], in: &map)
            carve(tile: tilesToCarve[1], in: &map)
            activeTiles.append(tilesToCarve[1])
        } while !activeTiles.isEmpty
    }
    
    private func carve(tile: GridPoint, in map: inout MutableGridMap) {
        map.setCell(location: tile, tile: .floor)
    }
    
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
    
    private func directionsWithEmptyNeighbors(from tile: GridPoint, in map: GridMap) -> [Direction] {
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
}
