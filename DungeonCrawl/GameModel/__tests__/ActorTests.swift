//
//  ActorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class ActorTests: XCTestCase {

    func testDoTurnAction_move() throws {
        // Arrange
        let sut = TestActor(name: "TestActor", cell: GridCell(x: 5, y: 5))
        
        // Act
        let animation = sut.doTurnAction(.move(to: GridCell(x: 4, y: 5), direction: .west))
        
        // Assert
        XCTAssertEqual(sut.cell, GridCell(x: 4, y: 5))
        XCTAssertEqual(animation, Animation.move(to: GridCell(x: 4, y: 5), heading: .west))
    }
    
    func testDoTurnAction_attack() throws {
        // Arrange
        let sut = TestActor(name: "TestActor", cell: GridCell(x: 5, y: 5))
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north))
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
    }
}

class TestActor: Actor {
    var name: String
    var cell: GridCell
    
    init(name: String, cell: GridCell) {
        self.name = name
        self.cell = cell
    }
}
