//
//  OccupiedCellsTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class OccupiedCellsTests: XCTestCase {

    func testNotOccupied() throws {
        // Arrange
        let sut = OccupiedCells()
        
        // Act
        let isOccupied = sut.isOccupied(cell: GridCell(x: 10, y: 10))
        
        // Assert
        XCTAssertFalse(isOccupied)
    }
    
    func testOccupied() throws {
        // Arrange
        let sut = OccupiedCells()
        sut.occupy(cell: GridCell(x: 10, y: 10))
        
        // Act
        let isOccupied = sut.isOccupied(cell: GridCell(x: 10, y: 10))
        
        // Assert
        XCTAssert(isOccupied)
        XCTAssertFalse(sut.isOccupied(cell: GridCell(x: 5, y: 5)))
    }
    
    func testFindEmptyCell() throws {
        // Arrange
        let sut = OccupiedCells()
        sut.occupy(cell: GridCell(x: 10, y: 10))
        let randomCells = [GridCell(x: 10, y: 10), GridCell(x: 5, y: 5)]

        // Act
        let cell = sut.findEmptyCell(randomCell: mockRandomCell(cells: randomCells))
        
        // Assert
        XCTAssertEqual(cell, GridCell(x: 5, y: 5))
    }
}

func mockRandomCell(cells: [GridCell]) -> (() -> GridCell) {
    let mockCells = cells
    var mockCellIndex = 0
    
    return {
        let cell = mockCells[mockCellIndex]
        mockCellIndex += 1
        return cell
    }
}
