//
//  ItemBuilderTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/30/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class ItemBuilderTests: XCTestCase {

    func testBuild_treasure() throws {
        let item = ItemBuilder(name: "treasure")
            .with(gold: 20)
            .build()
        XCTAssert(item.isTreasure)
        XCTAssertEqual(item.value, 20)
    }
    
    func testBuild_treasureFromItem() throws {
        let item = ItemBuilder(name: "treasure")
            .with(gold: 20)
            .build()
        let newItem = ItemBuilder(item: item).build()
        XCTAssertEqual(item, newItem)
    }

    func testBuild_armor() throws {
        let item = ItemBuilder(name: "armor")
            .with(equipmentSlot: .armor)
            .with(armorBonus: 1)
            .build()
        XCTAssertFalse(item.isTreasure)
        XCTAssertEqual(item.equipmentSlot, .armor)
        XCTAssertEqual(item.armorBonus, 1)
    }
    
    func testBuild_armorFromItem() throws {
        let item = ItemBuilder(name: "armor")
            .with(equipmentSlot: .armor)
            .with(armorBonus: 1)
            .build()
        let newItem = ItemBuilder(item: item).build()
        XCTAssertEqual(item, newItem)
    }
    
    func testBuild_enchantedArmor() throws {
        let armor = ItemBuilder(name: "armor")
            .with(equipmentSlot: .armor)
            .with(armorBonus: 1)
            .build()
        let enchantedArmor = ItemBuilder(item: armor)
            .with(enchantedArmorBonus: 1)
            .with(enchantedArmorBonus: 1)
            .build()
        XCTAssertEqual(enchantedArmor.enchantments.count, 1)
        XCTAssertEqual(enchantedArmor.enchantments.first, 2)
        XCTAssertEqual(enchantedArmor.additionalArmorBonus, 2)
    }
    
    func testBuild_weapon() throws {
        let item = ItemBuilder(name: "weapon")
            .with(equipmentSlot: .weapon)
            .with(damageDice: D4())
            .build()
        XCTAssertFalse(item.isTreasure)
        XCTAssertEqual(item.equipmentSlot, .weapon)
        XCTAssertEqual(item.damageDice, Dice(die: D4()))
    }
    
    func testBuild_weaponFromItem() throws {
        let item = ItemBuilder(name: "weapon")
            .with(equipmentSlot: .weapon)
            .with(damageDice: D4())
            .build()
        let newItem = ItemBuilder(item: item).build()
        XCTAssertEqual(item, newItem)
    }
    
    func testBuild_enchantedWeapon() throws {
        let weapon = ItemBuilder(name: "weapon")
            .with(equipmentSlot: .weapon)
            .with(damageDice: D4())
            .build()
        let enchantedWeapon = ItemBuilder(item: weapon)
            .with(enchantedDamageBonus: 1)
            .with(enchantedDamageBonus: 2)
            .build()
        XCTAssertEqual(enchantedWeapon.enchantments.count, 1)
        XCTAssertEqual(enchantedWeapon.enchantments.first, 3)
        XCTAssertEqual(enchantedWeapon.additionalDamageBonus, 3)
    }
}
