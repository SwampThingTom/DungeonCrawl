//
//  MazeGeneratorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class MazeGeneratorTests: XCTestCase {
    
    func testGenerate_emptyGrid() throws {
        // Arrange
        let gridSize = GridSize(width: 0, height: 0)
        var map: MutableGridMap = DungeonMap(size: gridSize)
        var regions = Regions()
        let sut = MazeGenerator()
        
        // Act
        sut.generate(map: &map, regions: &regions)
        
        // Assert
        XCTAssertEqual(regions.count, 0)
    }
    
    func testGenerate_tooSmallGrid() throws {
        // Arrange
        let gridSize = GridSize(width: 2, height: 2)
        var map: MutableGridMap = DungeonMap(size: gridSize)
        var regions = Regions()
        let sut = MazeGenerator()
        let expectedTiles = [
            [Tile.empty, Tile.empty],
            [Tile.empty, Tile.empty]
        ]
        let expectedMap = DungeonMap(tiles: expectedTiles)
        
        // Act
        sut.generate(map: &map, regions: &regions)
        
        // Assert
        XCTAssert(mapsAreEqual(map: map, otherMap: expectedMap))
        XCTAssertEqual(regions.count, 0)
    }
    
    func testGenerate_minimumMazeGrid() throws {
        // Arrange
        let gridSize = GridSize(width: 3, height: 3)
        var map: MutableGridMap = DungeonMap(size: gridSize)
        var regions = Regions()
        let sut = MazeGenerator()
        let expectedTiles = [
            [Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.floor, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty]
        ]
        let expectedMap = DungeonMap(tiles: expectedTiles)
        
        // Act
        sut.generate(map: &map, regions: &regions)
        
        // Assert
        XCTAssert(mapsAreEqual(map: map, otherMap: expectedMap))
        XCTAssertEqual(regions.count, 1)
    }
    
    func testGenerate_availableCells() throws {
        // Arrange
        let gridSize = GridSize(width: 7, height: 7)
        var map: MutableGridMap = DungeonMap(size: gridSize)
        var regions = Regions()
        let sut = MazeGenerator()
        
        // Act
        sut.generate(map: &map, regions: &regions)
        
        // Assert
        XCTAssertEqual(floorTileCount(in: map), 17)
        XCTAssert(allFloorTilesConnected(in: &map))
        XCTAssertEqual(regions.count, 1)
    }
    
    func testGenerate_noAvailableCells() throws {
        // Arrange
        let gridSize = GridSize(width: 7, height: 7)
        var original = DungeonMap(size: gridSize)
        original.fillCells(at: GridRect(x: 1, y: 1, width: 5, height: 5), with: .floor)
        var map: MutableGridMap = original.copy()
        var regions = Regions()
        let sut = MazeGenerator()
        
        // Act
        sut.generate(map: &map, regions: &regions)
        
        // Assert
        XCTAssert(mapsAreEqual(map: map, otherMap: original))
        XCTAssertEqual(regions.count, 0)
    }
    
    func testGenerate_someAvailableCells() throws {
        // Arrange
        let gridSize = GridSize(width: 7, height: 7)
        var map: MutableGridMap = DungeonMap(size: gridSize)
        map.fillCells(at: GridRect(x: 1, y: 1, width: 3, height: 3), with: .floor)
        let expectedTiles = [
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.empty, Tile.floor, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.empty, Tile.floor, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.empty, Tile.floor, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.floor, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty]
        ]
        let expectedMap = DungeonMap(tiles: expectedTiles)
        var regions = Regions()
        let sut = MazeGenerator()
        
        // Act
        sut.generate(map: &map, regions: &regions)
        
        // Assert
        XCTAssert(mapsAreEqual(map: map, otherMap: expectedMap))
        XCTAssertEqual(regions.count, 1)
    }
    
    func testGenerate_multipleRegions() throws {
        // Arrange
        let tiles = [
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            
            // Room
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],

            // Region 1
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],

            // Room
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],
            
            // Region 2
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],
            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty],

            // Room
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],
            [Tile.empty, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.floor, Tile.empty],

            [Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty, Tile.empty]
        ]
        var map: MutableGridMap = DungeonMap(tiles: tiles)
        var regions = Regions()
        let sut = MazeGenerator()
        
        // Act
        sut.generate(map: &map, regions: &regions)
        
        // Assert
        XCTAssertEqual(regions.count, 2)
    }
    
    /// MARK: - Test helpers
    
    /// Indicates whether the given maps are the same.
    func mapsAreEqual(map: GridMap, otherMap: GridMap) -> Bool {
        guard map.size == otherMap.size else { return false }
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let location = GridPoint(x: x, y: y)
                if map.cell(location: location) != otherMap.cell(location: location) {
                    return false
                }
            }
        }
        return true
    }

    /// The number of tiles in the map that are floor tiles.
    func floorTileCount(in map: GridMap) -> Int {
        var count = 0
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let location = GridPoint(x: x, y: y)
                if map.cell(location: location) == .floor {
                    count += 1
                }
            }
        }
        return count
    }
    
    /// Indicates whether all all of the floor tiles are connected.
    /// * Picks an arbitrary floor cell
    /// * Performs a flood fill to set all connected floor cells to empty
    /// * Verifies that the resulting map has only empty cells
    func allFloorTilesConnected(in map: inout MutableGridMap) -> Bool {
        guard let startPoint = firstFloorTile(in: map) else { return true }
        floodFill(map: &map, start: startPoint)
        return areAllTilesEmpty(in: map)
    }
    
    func floodFill(map: inout MutableGridMap, start: GridPoint) {
        var activeCells = [start]
        while let cell = activeCells.popLast() {
            map.setCell(location: cell, tile: .empty)
            for direction in Direction.allCases {
                let (x, y) = direction.offsets
                let neighbor = GridPoint(x: cell.x + x, y: cell.y + y)
                if map.cell(location: neighbor) == .floor {
                    activeCells.append(neighbor)
                }
            }
        }
    }
    
    /// Indicates whether all tiles are empty.
    func areAllTilesEmpty(in map: GridMap) -> Bool {
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let location = GridPoint(x: x, y: y)
                if map.cell(location: location) != .empty {
                    return false
                }
            }
        }
        return true
    }
    
    /// Returns the first found tile that is a floor tile.
    func firstFloorTile(in map: GridMap) -> GridPoint? {
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let location = GridPoint(x: x, y: y)
                if map.cell(location: location) == .floor {
                    return location
                }
            }
        }
        return nil
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
}
