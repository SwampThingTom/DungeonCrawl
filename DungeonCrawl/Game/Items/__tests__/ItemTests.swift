//
//  ItemTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/30/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class ItemTests: XCTestCase {
    
    func testDescription() throws {
        let treasure = Item(name: "treasure", isTreasure: true, value: 100)
        XCTAssertEqual(treasure.description, "treasure worth 100 gold pieces")
        
        let item = Item(name: "my item", value: 100)
        XCTAssertEqual(item.description, "my item")
        
        let armor = Item(name: "armor", value: 100, equipmentSlot: .armor, baseArmorBonus: 2)
        XCTAssertEqual(armor.description, "armor")
        
        let enchantedArmor = Item(name: "armor",
                                  value: 100,
                                  enchantments: [1],
                                  equipmentSlot: .armor,
                                  baseArmorBonus: 2,
                                  additionalArmorBonus: 1)
        XCTAssertEqual(enchantedArmor.description, "armor+1")
        
        let cursedArmor = Item(name: "armor",
                               value: 100,
                               enchantments: [-1],
                               equipmentSlot: .armor,
                               baseArmorBonus: 2,
                               additionalArmorBonus: 01)
        XCTAssertEqual(cursedArmor.description, "armor-1")
    }
    
    func testArmorBonus() throws {
        let sut = Item(name: "armor", value: 100, equipmentSlot: .armor, baseArmorBonus: 2)
        XCTAssertEqual(sut.armorBonus, 2)
    }
    
    func testEnchantedArmorBonus() throws {
        let sut = Item(name: "armor",
                       value: 100,
                       enchantments: [1],
                       equipmentSlot: .armor,
                       baseArmorBonus: 2,
                       additionalArmorBonus: 1)
        XCTAssertEqual(sut.armorBonus, 3)
    }
    
    func testDamageDie() throws {
        let sut = Item(name: "weapon",
                       value: 100,
                       enchantments: [1],
                       equipmentSlot: .weapon,
                       baseDamageDice: D4())
        let expectedDamageDice = Dice(die: D4())
        XCTAssertEqual(sut.damageDice, expectedDamageDice)
    }
    
    func testDamageDice() throws {
        let sut = Item(name: "weapon",
                       value: 100,
                       enchantments: [1],
                       equipmentSlot: .weapon,
                       baseDamageDice: Dice(die: D4(), numberOfDice: 2))
        let expectedDamageDice = Dice(die: D4(), numberOfDice: 2)
        XCTAssertEqual(sut.damageDice, expectedDamageDice)
    }

    func testEnchantedDamageDie() throws {
        let sut = Item(name: "weapon",
                       value: 100,
                       enchantments: [1],
                       equipmentSlot: .weapon,
                       baseDamageDice: D4(),
                       additionalDamageBonus: 1)
        let expectedDamageDice = Dice(die: D4(), numberOfDice: 1, modifier: 1)
        XCTAssertEqual(sut.damageDice, expectedDamageDice)
    }
    
    func testEnchantedDamageDice() throws {
        let sut = Item(name: "weapon",
                       value: 100,
                       enchantments: [1],
                       equipmentSlot: .weapon,
                       baseDamageDice: Dice(die: D4(), numberOfDice: 2, modifier: 2),
                       additionalDamageBonus: 1)
        let expectedDamageDice = Dice(die: D4(), numberOfDice: 2, modifier: 3)
        XCTAssertEqual(sut.damageDice, expectedDamageDice)
    }
}
