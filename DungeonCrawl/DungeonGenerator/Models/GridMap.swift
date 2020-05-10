//
//  GridMap.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/30/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

/// A map defined by a grid of cells, each containing a tile.
/// Individual cells are identified by locations ranging from
/// `(x: 0 ..< size.width, y: 0 ..< size.height)`.
protocol GridMap {
    
    /// The size of the grid.
    var size: GridSize { get }
    
    /// Indicates whether the given location is within the bounds of the grid.
    func isValid(cell: GridCell) -> Bool

    /// The value of the cell at the given location.
    /// Returns `nil` if the location is not within the grid.
    func tile(at cell: GridCell) -> Tile?
}

protocol MutableGridMap: GridMap {
    
    /// Sets the value of the cell at the given location.
    /// If location is not within the grid, throws fatal index out of range exception.
    mutating func setTile(at cell: GridCell, tile: Tile)
    
    /// Sets the value of all of the cells in the givne bounds.
    /// If locations are not within the grid, throws fatal index out of range exception.
    mutating func fillCells(at bounds: GridRect, with tile: Tile)
}

struct GridRect: Equatable {
    let origin: GridCell
    let size: GridSize
    
    var gridXRange: CountableRange<Int> {
        origin.x ..< origin.x + size.width
    }
    
    var gridYRange: CountableRange<Int> {
        origin.y ..< origin.y + size.height
    }
    
    init(x: Int, y: Int, width: Int, height: Int) {
        origin = GridCell(x: x, y: y)
        size = GridSize(width: width, height: height)
    }
}

struct GridCell: Equatable, Hashable {
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
        for y in 0 ..< size.height {
            for x in 0 ..< size.width {
                let tile = self.tile(at: GridCell(x: x, y: y))
                description += tile?.description ?? "?"
            }
            description += "\n"
        }
        return description
    }
}
