//
//  GridMap.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/30/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

/// A map defined by a grid of cells. Individual cells are identified by locations ranging from
/// `(x: 0 ..< size.width, y: 0 ..< size.height)`.
protocol GridMap {
    
    /// The size of the grid.
    var size: GridSize { get }
    
    /// Indicates whether the given location is within the bounds of the grid.
    func isValid(location: GridPoint) -> Bool

    /// The value of the cell at the given location.
    /// Returns `nil` if the location is not within the grid.
    func cell(location: GridPoint) -> Tile?
}

protocol MutableGridMap: GridMap {
    
    /// Sets the value of the cell at the given location.
    /// If location is not within the grid, throws fatal index out of range exception.
    mutating func setCell(location: GridPoint, tile: Tile)
    
    /// Sets the value of all of the cells in the givne bounds.
    /// If locations are not within the grid, throws fatal index out of range exception.
    mutating func fillCells(at bounds: GridRect, with tile: Tile)
}

struct GridRect: Equatable {
    let origin: GridPoint
    let size: GridSize
    
    var gridXRange: CountableRange<Int> {
        origin.x ..< origin.x + size.width
    }
    
    var gridYRange: CountableRange<Int> {
        origin.y ..< origin.y + size.height
    }
    
    init(x: Int, y: Int, width: Int, height: Int) {
        origin = GridPoint(x: x, y: y)
        size = GridSize(width: width, height: height)
    }
}

struct GridPoint: Equatable, Hashable {
    let x: Int
    let y: Int
}

struct GridSize: Equatable {
    let width: Int
    let height: Int
}

extension GridMap {
    
    var description: String {
        var description = String()
        for x in 0 ..< size.width {
            for y in 0 ..< size.height {
                let tile = cell(location: GridPoint(x: x, y: y))
                description += tile?.description ?? "?"
            }
            description += "\n"
        }
        return description
    }
}
