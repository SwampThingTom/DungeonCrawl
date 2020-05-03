//
//  Regions.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/3/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

/// A region represents a connected set of grid cells that are disconnected
/// from other regions.
struct Regions {
    
    /// Map of cell locations to region.
    var regionMap = Dictionary<GridPoint, Int>()
    
    /// The number of regions.
    var count: Int { currentRegion }
    
    private var currentRegion = 0
    
    /// Starts a new region.
    mutating func newRegion() {
        currentRegion += 1
    }
    
    /// Adds a cell location to the current region.
    mutating func add(cell location: GridPoint) {
        regionMap[location] = currentRegion
    }
    
    mutating func add(rect: GridRect) {
        for x in rect.gridXRange {
            for y in rect.gridYRange {
                add(cell: GridPoint(x: x, y: y))
            }
        }
    }
}
