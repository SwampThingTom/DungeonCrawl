//
//  ItemBuilder.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/22/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class ItemBuilder {
    
    private let name: String
    private var isTreasure: Bool = false
    private var value: Int = 0
    private var equipmentSlot: EquipmentSlot?
    private var armor: ArmorModel?
    private var weapon: WeaponModel?
    
    init(name: String) {
        self.name = name
    }
    
    func with(gold: Int) -> ItemBuilder {
        self.isTreasure = true
        self.value = gold
        return self
    }
    
    func with(equipmentSlot: EquipmentSlot) -> ItemBuilder {
        self.equipmentSlot = equipmentSlot
        return self
    }
    
    func with(armor: ArmorModel) -> ItemBuilder {
        self.armor = armor
        return self
    }
    
    func with(weapon: WeaponModel) -> ItemBuilder {
        self.weapon = weapon
        return self
    }
    
    func build() -> Item {
        return Item(name: name,
                    isTreasure: isTreasure,
                    value: value,
                    equipmentSlot: equipmentSlot,
                    armor: armor,
                    weapon: weapon)
    }
}

func createTreasure(worth gold: Int, name: String = "Gold Pieces") -> Item {
    return ItemBuilder(name: name)
        .with(gold: gold)
        .build()
}

func createLeatherArmor() -> Item {
    return ItemBuilder(name: "Leather")
        .with(equipmentSlot: .armor)
        .with(armor: ArmorModel(armorBonus: 2))
        .build()
}

func createDagger() -> Item {
    return ItemBuilder(name: "Dagger")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D4()))
        .build()
}

func createShortSword() -> Item {
    return ItemBuilder(name: "Short Sword")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D6()))
        .build()
}
