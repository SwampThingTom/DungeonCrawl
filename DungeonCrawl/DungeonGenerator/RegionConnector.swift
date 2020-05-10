//
//  RegionConnector.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/3/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

typealias CellRegionPair = (cell: GridCell, region: Int)

protocol RegionConnecting {
    func connect(regions: inout Regions, in map: inout MutableGridMap)
}

class RegionConnector: RegionConnecting {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }

    func connect(regions: inout Regions, in map: inout MutableGridMap) {
        while regions.count > 1 {
            let borderCells = regions.cellsBordering(region: 1, in: map)
            guard let connection = borderCells.randomElement(using: &randomNumberGenerator) else {
                assertionFailure("Unable to find cells bordering regions. Regions and map are out of sync.")
                return
            }
            addConnection(location: connection.cell, to: &map)
            // LATER: randomly add a second connector?
            regions.merge(from: connection.region, to: 1)
        }
    }
    
    private func addConnection(location: GridCell, to map: inout MutableGridMap) {
        map.setTile(at: location, tile: .door)
    }
}

private extension Regions {
    
    func cellsBordering(region: Int, in map: GridMap) -> [CellRegionPair] {
        var borderCells = [CellRegionPair]()
        for location in map.wallCells() {
            let neighborRegions = regionsConnectingCell(location: location, to: region, in: map)
            let locationBorderCells = neighborRegions.map { (cell: location, region: $0 ) }
            borderCells.append(contentsOf: locationBorderCells)
        }
        return borderCells
    }
    
    func regionsConnectingCell(location: GridCell, to region: Int, in map: GridMap) -> [Int] {
        var bordersRegion = false
        var neighborRegions = [Int]()
        for neighbor in map.neighboringCells(location) {
            guard let neighborRegion = regionMap[neighbor.cell] else {
                continue
            }
            if neighborRegion == region {
                bordersRegion = true
            } else {
                neighborRegions.append(neighborRegion)
            }
        }
        return bordersRegion ? neighborRegions : []
    }
}

private extension GridMap {
    
    func wallCells() -> [GridCell] {
        var wallCells = [GridCell]()
        // No need to test the outermost rows and columns.
        for x in 1 ..< self.size.width - 1 {
            for y in 1 ..< self.size.height - 1 {
                let location = GridCell(x: x, y: y)
                if tile(at: location) == .wall {
                    wallCells.append(location)
                }
            }
        }
        return wallCells
    }
}
