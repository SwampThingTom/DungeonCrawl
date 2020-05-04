//
//  MazeGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol MazeGenerating {
    func generate(map: inout MutableGridMap, regions: inout Regions)
}

class MazeGenerator: MazeGenerating {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }
    
    func generate(map: inout MutableGridMap, regions: inout Regions) {
        while true {
            let openTiles = openMapTiles(map)
            if openTiles.isEmpty {
                return
            }
            regions.newRegion()
            let startTile = openTiles.randomElement(using: &randomNumberGenerator)!
            generateMaze(at: startTile, in: &map, regions: &regions)
        }
    }
    
    private func openMapTiles(_ map: GridMap) -> [GridPoint] {
        var openTiles = [GridPoint]()
        for x in stride(from: 1, to: map.size.width, by: 2) {
            for y in stride(from: 1, to: map.size.height - 1, by: 2) {
                let location = GridPoint(x: x, y: y)
                if map.cell(location: location) == .wall {
                    openTiles.append(location)
                }
            }
        }
        return openTiles
    }
    
    private func generateMaze(at startTile: GridPoint, in map: inout MutableGridMap, regions: inout Regions) {
        carve(tile: startTile, in: &map, regions: &regions)
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
            let tilesToCarve = path(for: tile, heading: direction)
            carve(tile: tilesToCarve[0], in: &map, regions: &regions)
            carve(tile: tilesToCarve[1], in: &map, regions: &regions)
            activeTiles.append(tilesToCarve[1])
        } while !activeTiles.isEmpty
    }
    
    private func carve(tile: GridPoint, in map: inout MutableGridMap, regions: inout Regions) {
        map.setCell(location: tile, tile: .floor)
        regions.add(cell: tile)
    }
    
    private func directionsWithEmptyNeighbors(from tile: GridPoint, in map: GridMap) -> [Direction] {
        var directionsWithEmptyNeighbors = [Direction]()
        for neighbor in map.neighboringCells(tile, distance: 2) {
            if map.cell(location: neighbor.cell) == .wall {
                directionsWithEmptyNeighbors.append(neighbor.direction)
            }
        }
        return directionsWithEmptyNeighbors
    }
    
    private func path(for tile: GridPoint, heading: Direction) -> [GridPoint] {
        let (x, y) = heading.gridOffset
        return [
            GridPoint(x: tile.x + x, y: tile.y + y),
            GridPoint(x: tile.x + 2 * x, y: tile.y + 2 * y)
        ]
    }
}
