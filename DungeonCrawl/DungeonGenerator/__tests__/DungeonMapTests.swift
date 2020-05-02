//
//  DungeonMapTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonMapTests: XCTestCase {

    func testInit_tiles_noCells() throws {
        // Arrange
        let tiles = [[Tile]]()
        
        // Act
        let sut = DungeonMap.init(tiles: tiles)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 0, height: 0))
        XCTAssertFalse(sut.isValid(location: GridPoint(x: 0, y: 0)))
        XCTAssertNil(sut.cell(location: GridPoint(x: 0, y: 0)))
    }
    
    func testInit_tiles_emptyRow() throws {
        // Arrange
        let tiles = [[Tile]].init(arrayLiteral: [Tile]())
        
        // Act
        let sut = DungeonMap.init(tiles: tiles)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 0, height: 0))
        XCTAssertFalse(sut.isValid(location: GridPoint(x: 0, y: 0)))
        XCTAssertNil(sut.cell(location: GridPoint(x: 0, y: 0)))
    }
    
    func testInit_tiles_oneCell() throws {
        // Arrange
        let tiles = [[Tile.empty]]
        let validCell = GridPoint(x: 0, y: 0)
        let invalidCell = GridPoint(x: 1, y: 1)
        
        // Act
        let sut = DungeonMap.init(tiles: tiles)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 1, height: 1))
        
        XCTAssert(sut.isValid(location: validCell))
        XCTAssertEqual(sut.cell(location: validCell), .empty)
        
        XCTAssertFalse(sut.isValid(location: invalidCell))
        XCTAssertNil(sut.cell(location: invalidCell))
    }
    
    func testInit_tiles_multipleCells() throws {
        // Arrange
        let size = GridSize(width: 10, height: 6)
        let tiles = [[Tile]](repeating: [Tile](repeating: .empty, count: size.height),
                             count: size.width)
        let originCell = GridPoint(x: 0, y: 0)
        let boundaryCell = GridPoint(x: 9, y: 5)
        let invalidCell = GridPoint(x: 10, y: 6)
        
        // Act
        let sut = DungeonMap.init(tiles: tiles)

        // Assert
        XCTAssertEqual(sut.size, size)
        
        XCTAssert(sut.isValid(location: originCell))
        XCTAssertEqual(sut.cell(location: originCell), .empty)
        
        XCTAssert(sut.isValid(location: boundaryCell))
        XCTAssertEqual(sut.cell(location: boundaryCell), .empty)

        XCTAssertFalse(sut.isValid(location: invalidCell))
        XCTAssertNil(sut.cell(location: invalidCell))
    }
    
    func testInit_size_noCells() throws {
        // Arrange
        let size = GridSize(width: 0, height: 0)
        
        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 0, height: 0))
        XCTAssertFalse(sut.isValid(location: GridPoint(x: 0, y: 0)))
        XCTAssertNil(sut.cell(location: GridPoint(x: 0, y: 0)))
    }
    
    func testInit_size_zeroHeight() throws {
        // Arrange
        let size = GridSize(width: 1, height: 0)

        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 0, height: 0))
        XCTAssertFalse(sut.isValid(location: GridPoint(x: 0, y: 0)))
        XCTAssertNil(sut.cell(location: GridPoint(x: 0, y: 0)))
    }
    
    func testInit_size_zeroWidth() throws {
        // Arrange
        let size = GridSize(width: 1, height: 0)

        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 0, height: 0))
        XCTAssertFalse(sut.isValid(location: GridPoint(x: 0, y: 0)))
        XCTAssertNil(sut.cell(location: GridPoint(x: 0, y: 0)))
    }

    func testInit_size_oneCell() throws {
        // Arrange
        let size = GridSize(width: 1, height: 1)
        let validCell = GridPoint(x: 0, y: 0)
        let invalidCell = GridPoint(x: 1, y: 1)
        
        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 1, height: 1))
        
        XCTAssert(sut.isValid(location: validCell))
        XCTAssertEqual(sut.cell(location: validCell), .empty)
        
        XCTAssertFalse(sut.isValid(location: invalidCell))
        XCTAssertNil(sut.cell(location: invalidCell))
    }
    
    func testInit_size_multipleCells() throws {
        // Arrange
        let size = GridSize(width: 10, height: 6)
        let originCell = GridPoint(x: 0, y: 0)
        let boundaryCell = GridPoint(x: 9, y: 5)
        let invalidCell = GridPoint(x: 10, y: 6)
        
        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, size)
        
        XCTAssert(sut.isValid(location: originCell))
        XCTAssertEqual(sut.cell(location: originCell), .empty)
        
        XCTAssert(sut.isValid(location: boundaryCell))
        XCTAssertEqual(sut.cell(location: boundaryCell), .empty)

        XCTAssertFalse(sut.isValid(location: invalidCell))
        XCTAssertNil(sut.cell(location: invalidCell))
    }
}
