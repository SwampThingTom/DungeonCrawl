//
//  GridCellMathTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/22/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class GridCellMathTests: XCTestCase {

    func testDistance() throws {
        let sut = GridCell(x: 10, y: 10)
        
        XCTAssertEqual(sut.distance(to: GridCell(x: 10, y: 10)), 0)
        
        XCTAssertEqual(sut.distance(to: GridCell(x: 10, y: 11)), 1)
        XCTAssertEqual(sut.distance(to: GridCell(x: 11, y: 10)), 1)
        XCTAssertEqual(sut.distance(to: GridCell(x: 11, y: 11)), 1)
        
        XCTAssertEqual(sut.distance(to: GridCell(x: 10, y: 12)), 2)
        XCTAssertEqual(sut.distance(to: GridCell(x: 12, y: 10)), 2)
        // LATER: Arguably this should be 3 since ideally we'd round up
        XCTAssertEqual(sut.distance(to: GridCell(x: 12, y: 12)), 2)
        
        XCTAssertEqual(sut.distance(to: GridCell(x: 10, y: 109)), 99)
        XCTAssertEqual(sut.distance(to: GridCell(x: 109, y: 10)), 99)
        XCTAssertEqual(sut.distance(to: GridCell(x: 109, y: 109)), 140)
    }
}
