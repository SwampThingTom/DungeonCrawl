//
//  Direction.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/3/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

enum Direction: CaseIterable {
    case north
    case east
    case south
    case west
}

extension Direction {
    
    var gridOffset: (x: Int, y: Int) {
        switch self {
        case .north: return (0, -1)
        case .east: return (1, 0)
        case .south: return (0, 1)
        case .west: return (-1, 0)
        }
    }
}

typealias NeighborCell = (direction: Direction, cell: GridPoint)

extension GridPoint {
    
    /// The `GridPoint` of the cell in the given direction.
    func neighbor(direction: Direction, distance: Int = 1) -> GridPoint {
        return GridPoint(x: x + distance * direction.gridOffset.x,
                         y: y + distance * direction.gridOffset.y)
    }
    
    /// The `GridPoint` in each of the four directions from the current cell.
    /// - Note: These may not all be valid cells on a particular `GridMap`.
    func neighbors(distance: Int = 1) -> [NeighborCell] {
        Direction.allCases.map { (
            direction: $0,
            cell: neighbor(direction: $0, distance: distance)
        ) }
    }
}

extension GridMap {
    
    /// The valid neighboring cells for the given cell.
    func neighboringCells(_ cell: GridPoint, distance: Int = 1) -> [NeighborCell] {
        return cell.neighbors(distance: distance).compactMap {
            isValid(location: $0.cell) ? $0 : nil
        }
    }
}
