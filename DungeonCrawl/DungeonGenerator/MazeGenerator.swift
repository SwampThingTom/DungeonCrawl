//
//  MazeGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
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
            let openCells = openMapCells(map)
            if openCells.isEmpty {
                return
            }
            regions.newRegion()
            let startCell = openCells.randomElement(using: &randomNumberGenerator)!
            generateMaze(at: startCell, in: &map, regions: &regions)
        }
    }
    
    private func openMapCells(_ map: GridMap) -> [GridCell] {
        var openCells = [GridCell]()
        for x in stride(from: 1, to: map.size.width, by: 2) {
            for y in stride(from: 1, to: map.size.height - 1, by: 2) {
                let location = GridCell(x: x, y: y)
                if map.tile(at: location) == .wall {
                    openCells.append(location)
                }
            }
        }
        return openCells
    }
    
    private func generateMaze(at startCell: GridCell, in map: inout MutableGridMap, regions: inout Regions) {
        carve(cell: startCell, in: &map, regions: &regions)
        var activeCells = [startCell]
        repeat {
            let cellIndex = Int.random(in: 0 ..< activeCells.count, using: &randomNumberGenerator)
            let cell = activeCells[cellIndex]
            
            let possibleDirections = directionsWithEmptyNeighbors(from: cell, in: map)
            if possibleDirections.isEmpty {
                activeCells.remove(at: cellIndex)
                continue
            }
            
            // LATER: prefer last direction
            let direction = possibleDirections.randomElement(using: &randomNumberGenerator)!
            let cellsToCarve = path(for: cell, heading: direction)
            carve(cell: cellsToCarve[0], in: &map, regions: &regions)
            carve(cell: cellsToCarve[1], in: &map, regions: &regions)
            activeCells.append(cellsToCarve[1])
        } while !activeCells.isEmpty
    }
    
    private func carve(cell: GridCell, in map: inout MutableGridMap, regions: inout Regions) {
        map.setTile(at: cell, tile: .floor)
        regions.add(cell: cell)
    }
    
    private func directionsWithEmptyNeighbors(from cell: GridCell, in map: GridMap) -> [Direction] {
        var directionsWithEmptyNeighbors = [Direction]()
        for neighbor in map.neighboringCells(cell, distance: 2) {
            if map.tile(at: neighbor.cell) == .wall {
                directionsWithEmptyNeighbors.append(neighbor.direction)
            }
        }
        return directionsWithEmptyNeighbors
    }
    
    private func path(for cell: GridCell, heading: Direction) -> [GridCell] {
        let (x, y) = heading.gridOffset
        return [
            GridCell(x: cell.x + x, y: cell.y + y),
            GridCell(x: cell.x + 2 * x, y: cell.y + 2 * y)
        ]
    }
}
