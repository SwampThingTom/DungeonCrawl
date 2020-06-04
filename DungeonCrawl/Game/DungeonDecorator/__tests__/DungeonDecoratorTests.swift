//
//  DungeonMapDecoratorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonDecoratorTests: XCTestCase {

    func testDecorate() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        
        let treasurePlacer = MockTreasurePlacer()
        treasurePlacer.mockedTreasure = [
            ItemModel(item: createTreasure(worth: 25), cell: GridCell(x: 1, y: 10)),
            ItemModel(item: createTreasure(worth: 20), cell: GridCell(x: 9, y: 5)),
            ItemModel(item: createTreasure(worth: 35), cell: GridCell(x: 15, y: 7))
        ]
        
        let itemPlacer = MockItemsPlacer()
        itemPlacer.mockedItems = [
            ItemModel(item: Item(name: "Item"), cell: GridCell(x: 4, y: 11))
        ]
        
        let enemyPlacer = MockEnemyPlacer()
        enemyPlacer.mockedEnemies = [
            EnemyModel(enemyType: .jellyCube, cell: GridCell(x: 14, y: 8)),
            EnemyModel(enemyType: .giantBat, cell: GridCell(x: 8, y: 4))
        ]
        
        let sut = DungeonDecorator(treasurePlacer: treasurePlacer,
                                   itemPlacer: itemPlacer,
                                   enemyPlacer: enemyPlacer)
        
        // Act
        let decorations = sut.decorate(dungeon: dungeon)
        
        // Assert
        let tileAtStartCell = dungeon.map.tile(at: decorations.playerStartCell)
        XCTAssertEqual(tileAtStartCell, .floor)
        XCTAssertEqual(decorations.enemies.count, 2)
        XCTAssertGreaterThanOrEqual(decorations.items.count, 4)
    }
    
    func testDecorate_questItem() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: threeRooms())
        let questItem = mockQuestitem()
        
        let treasurePlacer = MockTreasurePlacer()
        treasurePlacer.mockedTreasure = [
            ItemModel(item: createTreasure(worth: 25), cell: GridCell(x: 1, y: 10)),
            ItemModel(item: createTreasure(worth: 20), cell: GridCell(x: 9, y: 5)),
            ItemModel(item: createTreasure(worth: 35), cell: GridCell(x: 15, y: 7))
        ]
        
        let itemPlacer = MockItemsPlacer()
        itemPlacer.mockedItems = [
            ItemModel(item: Item(name: "Item"), cell: GridCell(x: 4, y: 11))
        ]
        
        let enemyPlacer = MockEnemyPlacer()
        enemyPlacer.mockedEnemies = [
            EnemyModel(enemyType: .jellyCube, cell: GridCell(x: 14, y: 8)),
            EnemyModel(enemyType: .giantBat, cell: GridCell(x: 8, y: 4))
        ]
        
        let sut = DungeonDecorator(treasurePlacer: treasurePlacer,
                                   itemPlacer: itemPlacer,
                                   enemyPlacer: enemyPlacer)
        
        // Act
        let decorations = sut.decorate(dungeon: dungeon, questItem: questItem)
        
        // Assert
        let tileAtStartCell = dungeon.map.tile(at: decorations.playerStartCell)
        XCTAssertEqual(tileAtStartCell, .floor)
        let questItemModel = decorations.items.first { $0.item.isQuestItem }
        let tileAtQuestItemCell = dungeon.map.tile(at: questItemModel!.cell)
        XCTAssertEqual(tileAtQuestItemCell, .floor)
        XCTAssertEqual(decorations.enemies.count, 2)
        XCTAssertGreaterThanOrEqual(decorations.items.count, 5)
    }
    
    func testDecorate_noRooms() throws {
        // Arrange
        let dungeon = DungeonModel(map: fiveRegionMap(), rooms: [])
        let sut = DungeonDecorator()
        
        // Act
        let decorations = sut.decorate(dungeon: dungeon)
        
        // Assert
        let tileAtStartCell = dungeon.map.tile(at: decorations.playerStartCell)
        XCTAssertEqual(tileAtStartCell, .floor)
        XCTAssertEqual(decorations.enemies.count, 0)
        XCTAssertEqual(decorations.items.count, 0)
    }
    
    func mockQuestitem() -> Item {
        return ItemBuilder.init(name: "Treasure of Mot").withQuestItem().build()
    }
}

class MockTreasurePlacer: TreasurePlacing {
    
    var mockedTreasure = [ItemModel]()
    
    func placeTreasure(in dungeon: DungeonModel, occupiedCells: OccupiedCells) -> [ItemModel] {
        return mockedTreasure
    }
}

class MockItemsPlacer: ItemPlacing {
    
    var mockedItems = [ItemModel]()
    
    func placeItems(in dungeon: DungeonModel, occupiedCells: OccupiedCells) -> [ItemModel] {
        return mockedItems
    }
}

class MockEnemyPlacer: EnemyPlacing {
    
    var mockedEnemies = [EnemyModel]()
    
    func placeEnemies(in dungeon: DungeonModel,
                      occupiedCells: OccupiedCells,
                      maxChallengeRating: Double) -> [EnemyModel] {
        return mockedEnemies
    }
}
