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
    var count: Int { activeRegions.count }
    
    private var currentRegion = 0
    private var activeRegions = Set<Int>()
    
    /// Starts a new region.
    mutating func newRegion() {
        currentRegion += 1
    }
    
    /// Adds a cell location to the current region.
    mutating func add(cell location: GridPoint) {
        regionMap[location] = currentRegion
        activeRegions.insert(currentRegion)
    }
    
    /// Adds all of the cells in the given rectangle to the current region.
    mutating func add(rect: GridRect) {
        for x in rect.gridXRange {
            for y in rect.gridYRange {
                add(cell: GridPoint(x: x, y: y))
            }
        }
    }
    
    /// Merges two regions by moving all of the cells in one region to the destination region.
    mutating func merge(from source: Int, to destination: Int) {
        regionMap = regionMap.mapValues { $0 == source ? destination : $0 }
        activeRegions.remove(source)
    }
}
