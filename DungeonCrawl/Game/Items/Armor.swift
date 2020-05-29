//
//  Armor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/27/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class Armor {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private var d100: D100
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        d100 = D100(randomNumberGenerator: randomNumberGenerator)
    }
    
    func random() -> Item {
        return ItemPicker.choose(from: armorOdds, d100: d100)
    }
    
    private lazy var armorOdds: [ItemPickerOdds] = {
        return ItemPicker.accumulatedOdds(for: armor)
    }()
}

/// Armor and the percentage chance of finding each randomly.
let armor: [ItemPickerOdds] = [
    (createLeatherArmor(), 20),         // leather          light   +1  (dnd: 11)
    (createStuddedLeatherArmor(), 15),  // studded leather  light   +2  (dnd: 12)
    (createChainShirt(), 15),           // chain shirt      light   +3  (dnd: 13, medium)
    (createScaleMail(), 15),            // scale mail       medium  +4  (dnd: 14)
    (createBreastPlate(), 10),          // breast plate     medium  +5  (dnd: 14)
    (createChainMail(), 5),             // chain mail       medium  +6  (dnd: 16, heavy)
    (createBandedMail(), 10),           // banded mail      heavy   +6  (dnd: -)
    (createSplintMail(), 5),            // splint mail      heavy   +7  (dnd: 17)
    (createPlateMail(), 5),             // plate mail       heavy   +8  (dnd: 18)
]

func createLeatherArmor() -> Item {
    return ItemBuilder(name: "leather")
        .with(equipmentSlot: .armor)
        .with(armorBonus: 1)
        .build()
}

func createStuddedLeatherArmor() -> Item {
    return ItemBuilder(name: "studded leather")
        .with(equipmentSlot: .armor)
        .with(armorBonus: 2)
        .build()
}

func createChainShirt() -> Item {
    return ItemBuilder(name: "chain shirt")
        .with(equipmentSlot: .armor)
        .with(armorBonus: 3)
        .build()
}

func createScaleMail() -> Item {
    return ItemBuilder(name: "scale mail")
        .with(equipmentSlot: .armor)
        .with(armorBonus: 4)
        .build()
}

func createBreastPlate() -> Item {
    return ItemBuilder(name: "breast plate")
        .with(equipmentSlot: .armor)
        .with(armorBonus: 5)
        .build()
}

func createChainMail() -> Item {
    return ItemBuilder(name: "chain mail")
        .with(equipmentSlot: .armor)
        .with(armorBonus: 6)
        .build()
}

func createBandedMail() -> Item {
    return ItemBuilder(name: "banded mail")
        .with(equipmentSlot: .armor)
        .with(armorBonus: 6)
        .build()
}

func createSplintMail() -> Item {
    return ItemBuilder(name: "splint mail")
        .with(equipmentSlot: .armor)
        .with(armorBonus: 7)
        .build()
}

func createPlateMail() -> Item {
    return ItemBuilder(name: "plate mail")
        .with(equipmentSlot: .armor)
        .with(armorBonus: 8)
        .build()
}
