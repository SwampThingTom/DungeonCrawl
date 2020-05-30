//
//  Potions.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/29/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class Potions {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private var d100: D100
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        d100 = D100(randomNumberGenerator: randomNumberGenerator)
    }
    
    func random() -> Item {
        return ItemPicker.choose(from: potionOdds, d100: d100)
    }
    
    private lazy var potionOdds: [ItemPickerOdds] = {
        return ItemPicker.accumulatedOdds(for: potions)
    }()
}

/// Potions and the percentage chance of finding each randomly.
let potions: [ItemPickerOdds] = [
    (createLightHealingPotion(), 66),
    (createEnhanceArmorPotion(), 17),
    (createEnhanceWeaponPotion(), 17),
]

func createLightHealingPotion() -> Item {
    return ItemBuilder(name: "Potion of Light Healing")
        .with(potion: .heal)
        .build()
}

func createEnhanceArmorPotion() -> Item {
    return ItemBuilder(name: "Oil of Shielding")
        .with(potion: .armorBonus)
        .build()
}

func createEnhanceWeaponPotion() -> Item {
    return ItemBuilder(name: "Oil of Sharpness")
        .with(potion: .damageBonus)
        .build()
}
