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
    private var armorBonus: Int?
    private var damageDice: DieRolling?
    private var potion: PotionType?
    
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
    
    func with(armorBonus: Int) -> ItemBuilder {
        self.armorBonus = armorBonus
        return self
    }
    
    func with(damageDice: DieRolling) -> ItemBuilder {
        self.damageDice = damageDice
        return self
    }
    
    func with(potion: PotionType) -> ItemBuilder {
        self.potion = potion
        return self
    }
    
    func build() -> Item {
        return Item(name: name,
                    isTreasure: isTreasure,
                    value: value,
                    equipmentSlot: equipmentSlot,
                    armorBonus: armorBonus,
                    damageDice: damageDice,
                    potion: potion)
    }
}

func createTreasure(worth gold: Int, name: String = "gold") -> Item {
    return ItemBuilder(name: name)
        .with(gold: gold)
        .build()
}
