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
    
    func testInitDice_die() throws {
        // Act
        let sut = Dice(die: D20())
        
        // Assert
        XCTAssertEqual(sut.die.sides, 20)
        XCTAssertEqual(sut.numberOfDice, 1)
        XCTAssertEqual(sut.modifier, 0)
    }
    
    func testInitDice_dice() throws {
        // Act
        let sut = Dice(die: D8(), numberOfDice: 2, modifier: 10)
        
        // Assert
        XCTAssertEqual(sut.die.sides, 8)
        XCTAssertEqual(sut.numberOfDice, 2)
        XCTAssertEqual(sut.modifier, 10)
    }
    
    func testInitDice_diceWithModifier() throws {
        // Act
        let sut = Dice(die: D10(), modifier: 3)
        
        // Assert
        XCTAssertEqual(sut.die.sides, 10)
        XCTAssertEqual(sut.numberOfDice, 1)
        XCTAssertEqual(sut.modifier, 3)
    }
    
    func testInitDice_dieWithModifier() throws {
        // Act
        let dice = Dice(die: D8(), numberOfDice: 2, modifier: 10)
        let sut = Dice(die: dice, plus: 3)
        
        // Assert
        XCTAssertEqual(sut.die.sides, 8)
        XCTAssertEqual(sut.numberOfDice, 2)
        XCTAssertEqual(sut.modifier, 13)
    }

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
    
    func testDice_description_noModifier() throws {
        // Arrange
        let die = D10()
        let sut = Dice(die: die, numberOfDice: 2, modifier: 0)
        
        // Act
        let description = sut.description
        
        // Assert
        XCTAssertEqual(description, "2d10")
    }

    func testDice_description_singleDie_noModifier() throws {
        // Arrange
        let die = D20()
        let sut = Dice(die: die, numberOfDice: 1, modifier: 0)
        
        // Act
        let description = sut.description
        
        // Assert
        XCTAssertEqual(description, "d20")
    }
    
    func testDice_description_singleDie_modifier() throws {
        // Arrange
        let die = D20()
        let sut = Dice(die: die, numberOfDice: 1, modifier: 5)
        
        // Act
        let description = sut.description
        
        // Assert
        XCTAssertEqual(description, "d20+5")
    }
}
