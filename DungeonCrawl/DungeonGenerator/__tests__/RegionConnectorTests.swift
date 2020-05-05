//
//  RegionConnectorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/3/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class RegionGeneratorTests: XCTestCase {
    
    func testGenerate_noRegions() throws {
        // Arrange
        var (regions, map) = emptyMap()
        let sut = RegionConnector()
        let expectedMap = (map as? DungeonMap)?.copy()
        
        // Act
        sut.connect(regions: &regions, in: &map)
        
        // Assert
        XCTAssertEqual(regions.count, 0)
        XCTAssert(map.isEqual(expectedMap!))
    }
    
    func testGenerate_oneRegion() throws {
        // Arrange
        var (regions, map) = singleTileMap()
        let sut = RegionConnector()
        let expectedMap = (map as? DungeonMap)?.copy()
        
        // Act
        sut.connect(regions: &regions, in: &map)
        
        // Assert
        XCTAssertEqual(regions.count, 1)
        XCTAssert(map.isEqual(expectedMap!))
    }
    
    func testGenerate_twoRegions() throws {
        // Arrange
        var (regions, map) = twoRegionMap()
        let sut = RegionConnector()
        
        // Act
        sut.connect(regions: &regions, in: &map)
        
        // Assert
        XCTAssertEqual(regions.count, 1)
        XCTAssert(map.connector(in: GridRect(x: 4, y: 1, width: 1, height: 3)))
    }
    
    func testGenerate_fiveRegions() throws {
        // Arrange
        var (regions, map) = fiveRegionMap()
        let sut = RegionConnector()
        let expectedConnectorRegion_2_or_3 = [
            GridRect(x: 6, y: 1, width: 1, height: 7),
            GridRect(x: 1, y: 8, width: 7, height: 1)
        ]
        let expectedConnectorRegion_4 = [
            GridRect(x: 10, y: 1, width: 1, height: 7),
            GridRect(x: 9, y: 8, width: 1, height: 1),
            GridRect(x: 8, y: 9, width: 1, height: 3),
            GridRect(x: 1, y: 12, width: 7, height: 1)
        ]
        let expectedConnectorRegion_5 = [
            GridRect(x: 13, y: 6, width: 3, height: 1),
            GridRect(x: 12, y: 7, width: 1, height: 3),
            GridRect(x: 13, y: 10, width: 3, height: 1)
        ]
        
        // Act
        sut.connect(regions: &regions, in: &map)
        
        // Assert
        XCTAssertEqual(regions.count, 1)
        XCTAssert(map.connector(inOneOf: expectedConnectorRegion_2_or_3))
        XCTAssert(map.connector(inOneOf: expectedConnectorRegion_4))
        XCTAssert(map.connector(inOneOf: expectedConnectorRegion_5))
    }
}

extension GridMap {
    
    func connector(in range: GridRect) -> Bool {
        for x in range.gridXRange {
            for y in range.gridYRange {
                if tile(at: GridCell(x: x, y: y)) == .door {
                    return true
                }
            }
        }
        return false
    }
    
    func connector(inOneOf ranges: [GridRect]) -> Bool {
         for range in ranges {
            if connector(in: range) {
                return true
            }
        }
        return false
    }
}

/// Returns a 0x0 map.
private func emptyMap() -> (Regions, MutableGridMap) {
    let mapBuilder = MockMapBuilder(size: GridSize(width: 0, height: 0))
    return mapBuilder.build()
}

/// Returns a 3x3 map with a single floor tile.
///
/// `***`
/// `*1*`
/// `***`
private func singleTileMap() -> (Regions, MutableGridMap) {
    let mapBuilder = MockMapBuilder(size: GridSize(width: 3, height: 3))
    mapBuilder.addRegion(origin: GridCell(x: 1, y: 1), description: ["_"])
    return mapBuilder.build()
}

/// Returns a 9x5 map with two regions.
///
/// `*********`
/// `*111*2*2*`
/// `*111*2*2*`
/// `*111*222*`
/// `*********`
private func twoRegionMap() -> (Regions, MutableGridMap) {
    let region1 = [
        "___",
        "___",
        "___"
    ]
    
    let region2 = [
        "_*_",
        "_*_",
        "___",
    ]
    
    let mapBuilder = MockMapBuilder(size: GridSize(width: 9, height: 5))
    mapBuilder.addRegion(origin: GridCell(x: 1, y: 1), description: region1)
    mapBuilder.addRegion(origin: GridCell(x: 5, y: 1), description: region2)
    return mapBuilder.build()
}

/// Returns a 17x15 map with five regions.
///
///    `                      1111111`
///    `01234567890123456`
/// 00: `*****************`
/// 01: `*1*111*222*44444*`
/// 02: `*1*1*1*222*4*4*4*`
/// 03: `*111*1*222*4*4*4*`
/// 04: `***1*1*222*4***4*`
/// 05: `*1*1*1*222*444*4*`
/// 06: `*1*1***222*4*****`
/// 07: `*11111*222*4*555*`
/// 08: `***********4*555*`
/// 09: `*3333333*4*4*555*`
/// 10: `*3333333*4*4*****`
/// 11: `*3333333*4*44444*`
/// 12: `*********4*****4*`
/// 13: `*444444444444444*`
/// 14: `*****************`
// swiftlint:disable function_body_length
private func fiveRegionMap() -> (Regions, MutableGridMap) {

    let region1 = [
        "_*___",
        "_*_*_",
        "___*_",
        "**_*_",
        "_*_*_",
        "_*_**",
        "_____"
    ]
    
    let region2 = [
        "___",
        "___",
        "___",
        "___",
        "___",
        "___",
        "___"
    ]
    
    let region3 = [
        "_______",
        "_______",
        "_______"
    ]
    
    let region4 = [
        "**********_____",
        "**********_*_*_",
        "**********_*_*_",
        "**********_***_",
        "**********___*_",
        "**********_****",
        "**********_****",
        "**********_****",
        "********_*_****",
        "********_*_****",
        "********_*_____",
        "********_*****_",
        "_______________"
    ]

    let region5 = [
        "___",
        "___",
        "___"
    ]
    
    let mapBuilder = MockMapBuilder(size: GridSize(width: 17, height: 15))
    mapBuilder.addRegion(origin: GridCell(x: 1, y: 1), description: region1)
    mapBuilder.addRegion(origin: GridCell(x: 7, y: 1), description: region2)
    mapBuilder.addRegion(origin: GridCell(x: 1, y: 9), description: region3)
    mapBuilder.addRegion(origin: GridCell(x: 1, y: 1), description: region4)
    mapBuilder.addRegion(origin: GridCell(x: 13, y: 7), description: region5)
    return mapBuilder.build()
}

private class MockMapBuilder {
    
    private var regions: Regions
    private var map: DungeonMap
    
    init(size: GridSize) {
        self.map = DungeonMap(size: size)
        self.regions = Regions()
    }
    
    func addRegion(origin: GridCell, description gridStrings: [String]) {
        regions.newRegion()
        for y in 0 ..< gridStrings.count {
            let gridString = gridStrings[y]
            var x = 0
            for index in gridString.indices {
                if gridString[index] == "_" {
                    let cell = GridCell(x: origin.x + x, y: origin.y + y)
                    regions.add(cell: cell)
                    map.setTile(at: cell, tile: .floor)
                }
                x += 1
            }
        }
    }
    
    func build() -> (Regions, DungeonMap) {
        return (regions, map)
    }
}
