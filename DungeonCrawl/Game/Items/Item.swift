//
//  Item.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/22/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

enum EquipmentSlot: Equatable {
    case armor
    case weapon
}

enum PotionType: Equatable {
    case heal
    case armorBonus
    case attackBonus
}

struct Item {
    var name: String
    
    /// Indicates the item is treasure. When picked up, it adds to the player's gold.
    var isTreasure: Bool = false
    
    /// The base value of the item.
    var value: Int = 0
    
    /// The slot where this item can be equipped or `nil` if not equippable.
    var equipmentSlot: EquipmentSlot?
    
    /// The armor bonus provided by this item.
    var armorBonus: Int?
    
    /// The damage this item does on a successful attack.
    var damageDice: DieRolling?
    
    /// The type of potion.
    var potion: PotionType?
}

extension Item: CustomStringConvertible {
    
    var description: String {
        return isTreasure ? "\(name) worth \(value) gold pieces" : name
    }
}

extension Item: Equatable {
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name &&
            lhs.isTreasure == rhs.isTreasure &&
            lhs.value == rhs.value &&
            lhs.equipmentSlot == rhs.equipmentSlot &&
            lhs.armorBonus == rhs.armorBonus &&
            lhs.damageDice?.sides == rhs.damageDice?.sides
    }
}
