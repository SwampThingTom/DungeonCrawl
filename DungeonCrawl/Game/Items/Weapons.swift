//
//  Weapons.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/27/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class Weapons {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private var d100: D100
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        d100 = D100(randomNumberGenerator: randomNumberGenerator)
    }
    
    func random() -> Item {
        let percent = d100.roll()
        return percent <= 65 ? randomSimpleWeapon() : randomMartialWeapon()
    }
    
    private func randomSimpleWeapon() -> Item {
        return ItemPicker.choose(from: simpleMeleeWeaponOdds, d100: d100)
    }
    
    private func randomMartialWeapon() -> Item {
        return ItemPicker.choose(from: martialMeleeWeaponOdds, d100: d100)
    }
    
    private lazy var simpleMeleeWeaponOdds: [ItemPickerOdds] = {
        return ItemPicker.accumulatedOdds(for: simpleMeleeWeapons)
    }()
    
    private lazy var martialMeleeWeaponOdds: [ItemPickerOdds] = {
        return ItemPicker.accumulatedOdds(for: martialMeleeWeapons)
    }()
}

// MARK: - Simple melee weapons

/// Simple melee weapons and the percentage chance of finding each randomly.
let simpleMeleeWeapons: [ItemPickerOdds] = [
    (createClub(), 20),        // club         1d4  bludgeon
    (createMace(), 10),        // mace         1d6  bludgeon
    (createDagger(), 25),      // dagger       1d4  pierce    throw
    (createSpear(), 10),       // spear        1d6  pierce    throw
    (createSickle(), 15),      // sickle       1d4  slash
    (createShortSword(), 10),  // short sword  1d6  slash
    (createHandAxe(), 10),     // hand axe     1d6  slash     throw
]

func createClub() -> Item {
    return ItemBuilder(name: "club")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D4()))
        .build()
}

func createMace() -> Item {
    return ItemBuilder(name: "mace")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D6()))
        .build()
}

func createDagger() -> Item {
    return ItemBuilder(name: "dagger")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D4()))
        .build()
}

func createSpear() -> Item {
    return ItemBuilder(name: "spear")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D6()))
        .build()
}

func createSickle() -> Item {
    return ItemBuilder(name: "sickle")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D4()))
        .build()
}

func createShortSword() -> Item {
    return ItemBuilder(name: "short sword")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D6()))
        .build()
}

func createHandAxe() -> Item {
    return ItemBuilder(name: "hand axe")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D6()))
        .build()
}

// MARK: - Martial melee weapons

/// Martial melee weapons and the percentage chance of finding each randomly.
let martialMeleeWeapons: [ItemPickerOdds] = [
    (createFlail(), 25),      // flail        1d8  bludgeon
    (createMaul(), 10),       // maul         2d6  bludgeon  2-hand
    (createLongSword(), 25),  // long sword   1d8  pierce
    (createPike(), 10),       // pike         1d10 pierce    2-hand
    (createBattleAxe(), 25),  // battle axe   1d8  slash
    (createGreatAxe(), 5),    // great axe    1d12 slash     2-hand
]

func createFlail() -> Item {
    return ItemBuilder(name: "flail")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D8()))
        .build()
}

func createMaul() -> Item {
    return ItemBuilder(name: "maul")
        .with(equipmentSlot: .weapon)
        // LATER: Should be 2d6. Need a way to represent multiple damage dice.
        .with(weapon: WeaponModel(damageDie: D12()))
        .build()
}

func createLongSword() -> Item {
    return ItemBuilder(name: "long sword")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D8()))
        .build()
}

func createPike() -> Item {
    return ItemBuilder(name: "pike")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D10()))
        .build()
}

func createBattleAxe() -> Item {
    return ItemBuilder(name: "battle axe")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D8()))
        .build()
}

func createGreatAxe() -> Item {
    return ItemBuilder(name: "great axe")
        .with(equipmentSlot: .weapon)
        .with(weapon: WeaponModel(damageDie: D12()))
        .build()
}
