//
//  DungeonSceneInteractorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonSceneInteractorTests: XCTestCase {

    func testCreateScene() throws {
        // Arrange
        let presenter = MockDungeonScenePresenter()
        
        let expectedDungeonModel = DungeonModel(map: fiveRegionMap(), rooms: [])
        let dungeonGenerator = MockDungeonGenerator()
        dungeonGenerator.mockGenerateDungeonModel = expectedDungeonModel
        
        let expectedDungeonDecorations = DungeonDecorations(playerStartCell: GridCell(x: 1, y: 13),
                                                            enemies: [])
        let dungeonDecorator = MockDungeonDecorator()
        dungeonDecorator.mockDecorations = expectedDungeonDecorations
        
        var sut = DungeonSceneInteractor()
        sut.presenter = presenter
        sut.dungeonGenerator = dungeonGenerator
        sut.dungeonDecorator = dungeonDecorator
        
        // Act
        sut.createScene(dungeonSize: expectedDungeonModel.map.size)
        
        // Assert
        XCTAssertEqual(presenter.presentSceneDungeonModel?.map.size, expectedDungeonModel.map.size)
        XCTAssertEqual(presenter.presentSceneDecorations, expectedDungeonDecorations)
    }
    
    func testTakeTurn_move() throws {
        // Arrange
        let playerAction = PlayerAction.move(to: GridCell(x: 5, y: 5), heading: .east)
        let mockTileMap = MockTileMap()
        let pointForGridCell = CGPoint(x: CGFloat(50.0), y: CGFloat(50.0))
        let nodeAction = NodeAction(nodeName: "player", action: .move(to: pointForGridCell, heading: .east))
        let expectedNodeActions = [nodeAction]
        let presenter = MockDungeonScenePresenter()
        var sut = DungeonSceneInteractor()
        sut.presenter = presenter
        
        // Act
        sut.takeTurn(playerAction: playerAction, tileMap: mockTileMap, playerNodeName: "player")
        
        // Assert
        XCTAssertEqual(presenter.presentActionsForTurnActions, expectedNodeActions)
        XCTAssertFalse(presenter.presentEndOfTurnCalled)
        presenter.presentEndOfTurnBlock!()
        XCTAssertTrue(presenter.presentEndOfTurnCalled)
    }
    
    func testTakeTurn_attack() throws {
        // Arrange
        let playerAction = PlayerAction.attack(heading: .west)
        let mockTileMap = MockTileMap()
        let nodeAction = NodeAction(nodeName: "player", action: .attack(heading: .west))
        let expectedNodeActions = [nodeAction]
        let presenter = MockDungeonScenePresenter()
        var sut = DungeonSceneInteractor()
        sut.presenter = presenter
        
        // Act
        sut.takeTurn(playerAction: playerAction, tileMap: mockTileMap, playerNodeName: "player")
        
        // Assert
        XCTAssertEqual(presenter.presentActionsForTurnActions, expectedNodeActions)
        XCTAssertFalse(presenter.presentEndOfTurnCalled)
        presenter.presentEndOfTurnBlock!()
        XCTAssertTrue(presenter.presentEndOfTurnCalled)
    }
}

class MockDungeonScenePresenter: DungeonScenePresenting {
        
    var presentSceneDungeonModel: DungeonModel?
    var presentSceneDecorations: DungeonDecorations?
    
    func presentScene(dungeon: DungeonModel, decorations: DungeonDecorations) {
        presentSceneDungeonModel = dungeon
        presentSceneDecorations = decorations
    }
    
    var presentActionsForTurnActions: [NodeAction]?
    var presentEndOfTurnBlock: (() -> Void)?
    
    func presentActionsForTurn(actions: [NodeAction], endOfTurnBlock: @escaping () -> Void) {
        presentActionsForTurnActions = actions
        presentEndOfTurnBlock = endOfTurnBlock
    }
    
    var presentEndOfTurnCalled = false
    
    func presentEndOfTurn() {
        presentEndOfTurnCalled = true
    }
}

class MockDungeonGenerator: DungeonGenerating {
    
    var mockGenerateDungeonModel: DungeonModel?
    
    func generate(size: GridSize) -> DungeonModel {
        return mockGenerateDungeonModel!
    }
}

class MockDungeonDecorator: DungeonDecorating {
    
    var mockDecorations: DungeonDecorations?
    
    func decorate(dungeon: DungeonModel) -> DungeonDecorations {
        return mockDecorations!
    }
}

/// Returns a 17x15 map with five regions.
///
///    `                      1111111`
///    `01234567890123456`
/// 00: `*****************`
/// 01: `*_*___*___*_____*`
/// 02: `*_*_*_*___*_*_*_*`
/// 03: `*___*_$___*_*_*_*`
/// 04: `***_*_*___*_***_*`
/// 05: `*_*_*_*___*___*_*`
/// 06: `*_*_***___*_***$*`
/// 07: `*_____*___*_*___*`
/// 08: `***$*******_*___*`
/// 09: `*_______*_*_*___*`
/// 10: `*_______*_*_*****`
/// 11: `*_______*_*_____*`
/// 12: `***$*****_*****_*`
/// 13: `*_______________*`
/// 14: `*****************`
private func fiveRegionMap() -> MutableGridMap {

    let tiles = [
        "_*___*___*_____",
        "_*_*_*___*_*_*_",
        "___*_$___*_*_*_",
        "**_*_*___*_***_",
        "_*_*_*___*___*_",
        "_*_***___*_***$",
        "_____*___*_*___",
        "**$*******_*___",
        "_______*_*_*___",
        "_______*_*_****",
        "_______*_*_____",
        "**$*****_*****_",
        "_______________"
    ]
    
    let mapBuilder = MockMapBuilder(size: GridSize(width: 17, height: 15))
    mapBuilder.addTiles(origin: GridCell(x: 1, y: 1), description: tiles)
    return mapBuilder.build()
}

private class MockMapBuilder {
    
    private var map: DungeonMap
    
    init(size: GridSize) {
        self.map = DungeonMap(size: size)
    }
    
    func addTiles(origin: GridCell, description gridStrings: [String]) {
        for y in 0 ..< gridStrings.count {
            let gridString = gridStrings[y]
            var x = 0
            for index in gridString.indices {
                if gridString[index] == "_" {
                    let cell = GridCell(x: origin.x + x, y: origin.y + y)
                    map.setTile(at: cell, tile: .floor)
                }
                if gridString[index] == "$" {
                    let cell = GridCell(x: origin.x + x, y: origin.y + y)
                    map.setTile(at: cell, tile: .door)
                }
                x += 1
            }
        }
    }
    
    func build() -> DungeonMap {
        return map
    }
}

class MockTileMap: GridCellProviding {
    func cell(for position: CGPoint) -> GridCell {
        return GridCell(x: Int(position.x / 10.0),
                        y: Int(position.y / 10.0))
    }
    
    func center(of cell: GridCell) -> CGPoint {
        return CGPoint(x: CGFloat(cell.x) * 10.0,
                       y: CGFloat(cell.y) * 10.0)
    }
}
