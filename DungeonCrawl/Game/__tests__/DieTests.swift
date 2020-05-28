//
//  DieTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/27/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DieTests: XCTestCase {
    
    func testDice_roll() throws {
        // Arrange
        let die = MockDie(nextRoll: 7)
        let sut = Dice(die: die)
        
        // Act
        let result = sut.roll()
        
        // Assert
        XCTAssertEqual(result, 7)
    }

    func testDice_roll_multiple() throws {
        // Arrange
        let die = MockDie(nextRoll: 7)
        let sut = Dice(die: die, numberOfDice: 3, modifier: 11)
        
        // Act
        let result = sut.roll()
        
        // Assert
        XCTAssertEqual(result, 32)
    }
    
    func testDice_description() throws {
        // Arrange
        let die = D20()
        let sut = Dice(die: die, numberOfDice: 3, modifier: 11)
        
        // Act
        let description = sut.description
        
        // Assert
        XCTAssertEqual(description, "3d20+11")
    }
}
