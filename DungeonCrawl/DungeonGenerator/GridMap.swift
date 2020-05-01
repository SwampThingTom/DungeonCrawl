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

    /// The value of the cell at the given location.
    /// Returns `nil` if the location is not within the grid
    func cell(location: GridPoint) -> Tile?
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

struct GridPoint: Equatable {
    let x: Int
    let y: Int
}

struct GridSize: Equatable {
    let width: Int
    let height: Int
}
