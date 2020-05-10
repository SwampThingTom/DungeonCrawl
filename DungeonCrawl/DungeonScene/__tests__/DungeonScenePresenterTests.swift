//
//  DungeonScenePresenterTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import SpriteKit
import XCTest

class DungeonScenePresenterTests: XCTestCase {

    func testPresentScene() throws {
        // Arrange
        let scene = MockDungeonScene()
        let tileSet = SKTileSet(named: "Dungeon")!
        let tileSize = CGSize(width: 32, height: 32)
        let map = fiveRegionMap()
        let dungeonModel = DungeonModel(map: map, rooms: [])
        let enemies = [
            EnemyModel(spriteName: "Enemy", cell: GridCell(x: 2, y: 2)),
            EnemyModel(spriteName: "Enemy", cell: GridCell(x: 13, y: 2)),
            EnemyModel(spriteName: "Enemy", cell: GridCell(x: 5, y: 9))
        ]
        let decorations = DungeonDecorations(playerStartCell: GridCell(x: 13, y: 3), enemies: enemies)
        var sut = DungeonScenePresenter(scene: scene, tileSet: tileSet, tileSize: tileSize)
        sut.enemySpriteProvider = MockEnemySpriteProvider()
        
        // Act
        sut.presentScene(dungeon: dungeonModel, decorations: decorations)
        
        // Assert
        let tileMap = scene.displaySceneTileMap!
        let dungeonMap = dungeonModel.map
        XCTAssertEqual(tileMap.numberOfColumns, dungeonMap.size.width)
        XCTAssertEqual(tileMap.numberOfRows, dungeonMap.size.height)
        XCTAssertEqual(tileMap.tileSet, tileSet)
        XCTAssertEqual(tileMap.tileSize, tileSize)
        
        let playerStartPosition = scene.displayScenePlayerStartPosition!
        let mapColumn = tileMap.tileColumnIndex(fromPosition: playerStartPosition)
        let mapRow = tileMap.tileRowIndex(fromPosition: playerStartPosition)
        let playerStartCell = GridCell(x: mapColumn, y: mapRow)
        XCTAssertEqual(playerStartCell, GridCell(x: 13, y: 3))
        
        XCTAssertEqual(scene.displaySceneEnemySprites?.count, enemies.count)
    }
    
    func testPresentActionsForTurn_move() throws {
        // Arrange
        let scene = MockDungeonScene()
        let tileSet = SKTileSet(named: "Dungeon")!
        let tileSize = CGSize(width: 32, height: 32)
        let point = CGPoint(x: CGFloat(50.0), y: CGFloat(50.0))
        let nodeActions = [NodeAction(nodeName: "player", action: SpriteAction.move(to: point, heading: .north))]
        let sut = DungeonScenePresenter(scene: scene, tileSet: tileSet, tileSize: tileSize)
        
        // Act
        sut.presentActionsForTurn(actions: nodeActions, endOfTurnBlock: {})
        
        // Assert
        XCTAssertEqual(scene.displaySpriteName, "player")
        XCTAssertEqual(scene.displaySpriteHeading, Direction.north)
        XCTAssertNotNil(scene.displayActionsForTurnAction)
    }
    
    func testPresentActionsForTurn_attack() throws {
        // Arrange
        let scene = MockDungeonScene()
        let tileSet = SKTileSet(named: "Dungeon")!
        let tileSize = CGSize(width: 32, height: 32)
        let nodeActions = [NodeAction(nodeName: "player", action: SpriteAction.attack(heading: .south))]
        let sut = DungeonScenePresenter(scene: scene, tileSet: tileSet, tileSize: tileSize)
        
        // Act
        sut.presentActionsForTurn(actions: nodeActions, endOfTurnBlock: {})
        
        // Assert
        XCTAssertNotNil(scene.displayActionsForTurnAction)
    }

    func testPresentEndOfTurn() throws {
        // Arrange
        let scene = MockDungeonScene()
        let tileSet = SKTileSet(named: "Dungeon")!
        let tileSize = CGSize(width: 32, height: 32)
        let sut = DungeonScenePresenter(scene: scene, tileSet: tileSet, tileSize: tileSize)
        
        // Act
        sut.presentEndOfTurn()
        
        // Assert
        XCTAssert(scene.displayEndOfTurnCalled)
    }
}

class MockDungeonScene: DungeonSceneDisplaying {
    
    var displaySceneTileMap: SKTileMapNode?
    var displayScenePlayerStartPosition: CGPoint?
    var displaySceneEnemySprites: [SKSpriteNode]?
    
    func displayScene(tileMap: SKTileMapNode, playerStartPosition: CGPoint, enemySprites: [SKSpriteNode]) {
        displaySceneTileMap = tileMap
        displayScenePlayerStartPosition = playerStartPosition
        displaySceneEnemySprites = enemySprites
    }
    
    var displayActionsForTurnAction: SKAction?
    
    func displayActionForTurn(action: SKAction) {
        displayActionsForTurnAction = action
    }
    
    var displaySpriteHeading: Direction?
    var displaySpriteName: String?
    
    func animateSprite(heading: Direction, forSpriteNamed spriteName: String) {
        displaySpriteHeading = heading
        displaySpriteName = spriteName
    }
    
    var displayEndOfTurnCalled = false
    
    func displayEndOfTurn() {
        displayEndOfTurnCalled = true
    }
}

class MockEnemySpriteProvider: EnemySpriteProviding {
    
    func sprite(for enemyNamed: String) -> SKSpriteNode? {
        return SKSpriteNode()
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
