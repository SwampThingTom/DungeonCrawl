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
        XCTAssertFalse(sut.isValid(cell: GridCell(x: 0, y: 0)))
        XCTAssertNil(sut.tile(at: GridCell(x: 0, y: 0)))
    }
    
    func testInit_tiles_emptyColumn() throws {
        // Arrange
        let tiles = [[Tile]].init(arrayLiteral: [Tile]())
        
        // Act
        let sut = DungeonMap.init(tiles: tiles)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 0, height: 0))
        XCTAssertFalse(sut.isValid(cell: GridCell(x: 0, y: 0)))
        XCTAssertNil(sut.tile(at: GridCell(x: 0, y: 0)))
    }
    
    func testInit_tiles_oneCell() throws {
        // Arrange
        let tiles = [[Tile.wall]]
        let validCell = GridCell(x: 0, y: 0)
        let invalidCell = GridCell(x: 1, y: 1)
        
        // Act
        let sut = DungeonMap.init(tiles: tiles)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 1, height: 1))
        
        XCTAssert(sut.isValid(cell: validCell))
        XCTAssertEqual(sut.tile(at: validCell), .wall)
        
        XCTAssertFalse(sut.isValid(cell: invalidCell))
        XCTAssertNil(sut.tile(at: invalidCell))
    }
    
    func testInit_tiles_multipleCells() throws {
        // Arrange
        let size = GridSize(width: 11, height: 7)
        let tiles = [[Tile]](repeating: [Tile](repeating: .wall, count: size.width),
                             count: size.height)
        let originCell = GridCell(x: 0, y: 0)
        let boundaryCell = GridCell(x: 9, y: 5)
        let invalidCell = GridCell(x: 11, y: 7)
        
        // Act
        let sut = DungeonMap.init(tiles: tiles)

        // Assert
        XCTAssertEqual(sut.size, size)
        
        XCTAssert(sut.isValid(cell: originCell))
        XCTAssertEqual(sut.tile(at: originCell), .wall)
        
        XCTAssert(sut.isValid(cell: boundaryCell))
        XCTAssertEqual(sut.tile(at: boundaryCell), .wall)

        XCTAssertFalse(sut.isValid(cell: invalidCell))
        XCTAssertNil(sut.tile(at: invalidCell))
    }
    
    func testInit_size_noCells() throws {
        // Arrange
        let size = GridSize(width: 0, height: 0)
        
        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 0, height: 0))
        XCTAssertFalse(sut.isValid(cell: GridCell(x: 0, y: 0)))
        XCTAssertNil(sut.tile(at: GridCell(x: 0, y: 0)))
    }
    
    func testInit_size_zeroHeight() throws {
        // Arrange
        let size = GridSize(width: 1, height: 0)

        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 0, height: 0))
        XCTAssertFalse(sut.isValid(cell: GridCell(x: 0, y: 0)))
        XCTAssertNil(sut.tile(at: GridCell(x: 0, y: 0)))
    }
    
    func testInit_size_zeroWidth() throws {
        // Arrange
        let size = GridSize(width: 0, height: 1)

        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 0, height: 0))
        XCTAssertFalse(sut.isValid(cell: GridCell(x: 0, y: 0)))
        XCTAssertNil(sut.tile(at: GridCell(x: 0, y: 0)))
    }

    func testInit_size_oneCell() throws {
        // Arrange
        let size = GridSize(width: 1, height: 1)
        let validCell = GridCell(x: 0, y: 0)
        let invalidCell = GridCell(x: 1, y: 1)
        
        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, GridSize(width: 1, height: 1))
        
        XCTAssert(sut.isValid(cell: validCell))
        XCTAssertEqual(sut.tile(at: validCell), .wall)
        
        XCTAssertFalse(sut.isValid(cell: invalidCell))
        XCTAssertNil(sut.tile(at: invalidCell))
    }
    
    func testInit_size_multipleCells() throws {
        // Arrange
        let size = GridSize(width: 11, height: 7)
        let originCell = GridCell(x: 0, y: 0)
        let boundaryCell = GridCell(x: 9, y: 5)
        let invalidCell = GridCell(x: 11, y: 7)
        
        // Act
        let sut = DungeonMap.init(size: size)

        // Assert
        XCTAssertEqual(sut.size, size)
        
        XCTAssert(sut.isValid(cell: originCell))
        XCTAssertEqual(sut.tile(at: originCell), .wall)
        
        XCTAssert(sut.isValid(cell: boundaryCell))
        XCTAssertEqual(sut.tile(at: boundaryCell), .wall)

        XCTAssertFalse(sut.isValid(cell: invalidCell))
        XCTAssertNil(sut.tile(at: invalidCell))
    }
    
    func testSetCell() throws {
        // Arrange
        let size = GridSize(width: 11, height: 7)
        var sut = DungeonMap.init(size: size)
        let cellToSet = GridCell(x: 0, y: 0)

        // Act
        sut.setTile(at: cellToSet, tile: .floor)

        // Assert
        XCTAssertEqual(sut.tile(at: cellToSet), .floor)
    }
    
    func testFillCells() throws {
        // Arrange
        let size = GridSize(width: 11, height: 7)
        var sut = DungeonMap.init(size: size)
        let rect = GridRect(x: 2, y: 2, width: 3, height: 3)
        let outsideRect1 = GridCell(x: rect.origin.x + rect.size.width,
                                     y: rect.origin.y + rect.size.height - 1)
        let outsideRect2 = GridCell(x: rect.origin.x + rect.size.width - 1,
                                     y: rect.origin.y + rect.size.height)

        // Act
        sut.fillCells(at: rect, with: .floor)

        // Assert
        for x in rect.origin.x ..< rect.origin.x + rect.size.width {
            for y in rect.origin.y ..< rect.origin.y + rect.size.height {
                let location = GridCell(x: x, y: y)
                XCTAssertEqual(sut.tile(at: location), .floor)
            }
        }
        XCTAssertEqual(sut.tile(at: outsideRect1), .wall)
        XCTAssertEqual(sut.tile(at: outsideRect2), .wall)
    }

    func testFillCells_empty() throws {
        // Arrange
        let size = GridSize(width: 11, height: 7)
        var sut = DungeonMap.init(size: size)
        let rect = GridRect(x: 0, y: 0, width: 0, height: 0)
        let expected = DungeonMap.init(size: size)

        // Act
        sut.fillCells(at: rect, with: .floor)

        // Assert
        XCTAssertEqual(sut.size, expected.size)
        for x in 0 ..< sut.size.width {
            for y in 0 ..< sut.size.height {
                let location = GridCell(x: x, y: y)
                XCTAssertEqual(sut.tile(at: location), expected.tile(at: location))
            }
        }
    }
    
    func testFillCells_emptyRow() throws {
        // Arrange
        let size = GridSize(width: 11, height: 7)
        var sut = DungeonMap.init(size: size)
        let rect = GridRect(x: 0, y: 0, width: 1, height: 0)
        let expected = DungeonMap.init(size: size)

        // Act
        sut.fillCells(at: rect, with: .floor)

        // Assert
        XCTAssertEqual(sut.size, expected.size)
        for x in 0 ..< sut.size.width {
            for y in 0 ..< sut.size.height {
                let location = GridCell(x: x, y: y)
                XCTAssertEqual(sut.tile(at: location), expected.tile(at: location))
            }
        }
    }
    
    func testFillCells_emptyColumn() throws {
        // Arrange
        let size = GridSize(width: 11, height: 7)
        var sut = DungeonMap.init(size: size)
        let rect = GridRect(x: 0, y: 0, width: 0, height: 1)
        let expected = DungeonMap.init(size: size)

        // Act
        sut.fillCells(at: rect, with: .floor)

        // Assert
        XCTAssertEqual(sut.size, expected.size)
        for x in 0 ..< sut.size.width {
            for y in 0 ..< sut.size.height {
                let location = GridCell(x: x, y: y)
                XCTAssertEqual(sut.tile(at: location), expected.tile(at: location))
            }
        }
    }

    func testFillCells_all() throws {
        // Arrange
        let size = GridSize(width: 11, height: 7)
        var sut = DungeonMap.init(size: size)
        let rect = GridRect(x: 0, y: 0, width: size.width, height: size.height)

        // Act
        sut.fillCells(at: rect, with: .floor)

        // Assert
        XCTAssertEqual(sut.size, size)
        for x in 0 ..< sut.size.width {
            for y in 0 ..< sut.size.height {
                let location = GridCell(x: x, y: y)
                XCTAssertEqual(sut.tile(at: location), .floor)
            }
        }
    }
}
