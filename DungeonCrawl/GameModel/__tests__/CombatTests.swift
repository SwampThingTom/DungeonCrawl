//
//  CombatTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class CombatTests: XCTestCase {

    func testAttack() throws {
        // Arrange
        let sut = Combat()
        let attacker = MockActor(name: "Attacker", cell: GridCell(x: 0, y: 0), combat: sut)
        let defender = MockActor(name: "Defender", cell: GridCell(x: 1, y: 0), combat: sut)
        
        // Act
        let damage = sut.attack(attacker: attacker, defender: defender)
        
        // Assert
        XCTAssertEqual(damage, 1)
    }
}

class MockActor: Actor {
    var combat: CombatProviding
    var name: String
    var cell: GridCell
    
    init(name: String, cell: GridCell, combat: CombatProviding) {
        self.name = name
        self.cell = cell
        self.combat = combat
    }
}
