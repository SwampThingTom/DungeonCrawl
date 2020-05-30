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
    private var enchantments = [Int]()
    private var equipmentSlot: EquipmentSlot?
    private var armorBonus: Int?
    private var additionalArmorBonus: Int?
    private var damageDice: DieRolling?
    private var additionalDamageBonus: Int?
    private var potion: PotionType?
    
    init(name: String) {
        self.name = name
    }
    
    init(item: Item) {
        self.name = item.name
        self.isTreasure = item.isTreasure
        self.value = item.value
        self.equipmentSlot = item.equipmentSlot
        self.armorBonus = item.armorBonus
        self.additionalArmorBonus = item.additionalArmorBonus
        self.damageDice = item.damageDice
        self.additionalDamageBonus = item.additionalDamageBonus
        self.potion = item.potion
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
    
    func with(enchantedArmorBonus: Int) -> ItemBuilder {
        guard let additionalArmorBonus = additionalArmorBonus else {
            self.additionalArmorBonus = enchantedArmorBonus
            enchantments.append(enchantedArmorBonus)
            return self
        }
        self.additionalArmorBonus = additionalArmorBonus + enchantedArmorBonus
        enchantments[0] += enchantedArmorBonus
        return self
    }
    
    func with(damageDice: DieRolling) -> ItemBuilder {
        self.damageDice = damageDice
        return self
    }
    
    func with(enchantedDamageBonus: Int) -> ItemBuilder {
        guard let additionalDamageBonus = additionalDamageBonus else {
            self.additionalDamageBonus = enchantedDamageBonus
            enchantments.append(enchantedDamageBonus)
            return self
        }
        self.additionalDamageBonus = additionalDamageBonus + enchantedDamageBonus
        enchantments[0] += enchantedDamageBonus
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
                    enchantments: enchantments,
                    equipmentSlot: equipmentSlot,
                    baseArmorBonus: armorBonus,
                    additionalArmorBonus: additionalArmorBonus,
                    baseDamageDice: damageDice,
                    additionalDamageBonus: additionalDamageBonus,
                    potion: potion)
    }
}

func createTreasure(worth gold: Int, name: String = "gold") -> Item {
    return ItemBuilder(name: name)
        .with(gold: gold)
        .build()
}
