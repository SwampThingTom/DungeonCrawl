//
//  ItemComponentTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/30/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class ItemComponentTests: XCTestCase {

    func testEnchant_armor() throws {
        // Arrange
        let armor = ItemBuilder.init(name: "armor")
            .with(equipmentSlot: .armor)
            .with(armorBonus: 1)
            .build()
        let sut = ItemComponent(item: armor)
        
        // Act
        sut.enchant(armorBonus: 2)
        
        // Assert
        XCTAssertEqual(sut.item.armorBonus, 3)
    }
    
    func testEnchant_weaponDamage() throws {
        // Arrange
        let weapon = ItemBuilder.init(name: "weapon")
            .with(equipmentSlot: .weapon)
            .with(damageDice: D4())
            .build()
        let sut = ItemComponent(item: weapon)
        
        // Act
        sut.enchant(damageBonus: 2)
        
        // Assert
        let expectedDamageDice = Dice(die: D4(), numberOfDice: 1, modifier: 2)
        XCTAssertEqual(sut.item.damageDice, expectedDamageDice)
    }}
