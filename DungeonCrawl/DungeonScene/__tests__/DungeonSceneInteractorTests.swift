//
//  DungeonSceneInteractorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonSceneInteractorTests: XCTestCase {

    func testCreateScene() throws {
        // Arrange
        let dungeonSize = GridSize(width: 25, height: 25)
        let presenter = MockDungeonScenePresenter()
        let dungeonGenerator = MockDungeonGenerator()
        var sut = DungeonSceneInteractor()
        sut.presenter = presenter
        sut.dungeonGenerator = dungeonGenerator
        
        // Act
        sut.createScene(dungeonSize: dungeonSize)
        
        // Assert
        XCTAssertEqual(presenter.presentSceneDungeonModel?.map.size, dungeonSize)
    }
}

class MockDungeonScenePresenter: DungeonScenePresenting {
    
    var presentSceneDungeonModel: DungeonModel?
    
    func presentScene(dungeon: DungeonModel) {
        presentSceneDungeonModel = dungeon
    }
}

class MockDungeonGenerator: DungeonGenerating {
    
    func generate(size: GridSize) -> DungeonModel {
        let map = DungeonMap(size: size)
        return DungeonModel(map: map, rooms: [])
    }
}
