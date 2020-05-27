//
//  ItemPickerTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/27/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class ItemPickerTests: XCTestCase {

    func testAccumulatedOdds() throws {
        // Arrange
        let items: [ItemPickerOdds] = [
            (Item(name: "dagger"), 20),
            (Item(name: "sword"), 50),
            (Item(name: "great axe"), 30)
        ]
        let expectedAccumulatedOdds: [ItemPickerOdds] = [
            (Item(name: "dagger"), 20),
            (Item(name: "sword"), 70),
            (Item(name: "great axe"), 100)
        ]
        
        // Act
        let accumulatedOdds = ItemPicker.accumulatedOdds(for: items)
        
        // Assert
        for index in 0..<items.count {
            XCTAssertEqual(accumulatedOdds[index].0, expectedAccumulatedOdds[index].0)
            XCTAssertEqual(accumulatedOdds[index].1, expectedAccumulatedOdds[index].1)
        }
    }
    
    func testChoose() throws {
        let mockD100 = MockD100()
        let items: [ItemPickerOdds] = [
            (Item(name: "dagger"), 20),
            (Item(name: "sword"), 70),
            (Item(name: "great axe"), 100)
        ]
        
        mockD100.nextRoll = 1
        var item = ItemPicker.choose(from: items, d100: mockD100)
        XCTAssertEqual(item, items[0].0)
        
        mockD100.nextRoll = 20
        item = ItemPicker.choose(from: items, d100: mockD100)
        XCTAssertEqual(item, items[0].0)
        
        mockD100.nextRoll = 21
        item = ItemPicker.choose(from: items, d100: mockD100)
        XCTAssertEqual(item, items[1].0)
        
        mockD100.nextRoll = 70
        item = ItemPicker.choose(from: items, d100: mockD100)
        XCTAssertEqual(item, items[1].0)
        
        mockD100.nextRoll = 71
        item = ItemPicker.choose(from: items, d100: mockD100)
        XCTAssertEqual(item, items[2].0)
        
        mockD100.nextRoll = 100
        item = ItemPicker.choose(from: items, d100: mockD100)
        XCTAssertEqual(item, items[2].0)
    }
}

class MockD100: D100 {
    
    var nextRoll: Int = 0
    
    override func roll() -> Int {
        return nextRoll
    }
}
