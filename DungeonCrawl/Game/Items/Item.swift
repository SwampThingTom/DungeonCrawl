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
    case damageBonus
}

struct Item {
    
    /// Basic name of the item.
    /// Use `description` for a more complete description of the item.
    var name: String
    
    /// Indicates the item is treasure. When picked up, it adds to the player's gold.
    var isTreasure: Bool = false
    
    /// The base value of the item.
    var value: Int = 0
    
    /// Enchantment modifiers for the item.
    /// This is used solely to modify the description of the item. The actual enchantment
    /// bonuses should be added to the specific things they modify. For example, an
    /// enchantment that affects armor bonus should be added to `additionalArmorBonus`.
    var enchantments = [Int]()
    
    /// The slot where this item can be equipped or `nil` if not equippable.
    var equipmentSlot: EquipmentSlot?
    
    /// The base armor bonus for the item.
    var baseArmorBonus: Int?
    
    /// Additional armor bonus for the item.
    var additionalArmorBonus: Int?
    
    /// The combined armor bonus for the item.
    var armorBonus: Int? {
        guard let baseArmorBonus = baseArmorBonus else { return nil }
        return baseArmorBonus + (additionalArmorBonus ?? 0)
    }
    
    /// The base damage this item does on a successful attack.
    var baseDamageDice: DieRolling?
    
    /// Additional damage bonus for the item.
    var additionalDamageBonus: Int?
    
    /// The damage this item does on a successful attack.
    var damageDice: Dice? {
        guard let die = baseDamageDice else { return nil }
        let dice = (die as? Dice) ?? Dice(die: die)
        guard let additionalDamageBonus = additionalDamageBonus else { return dice }
        return Dice(die: dice, plus: additionalDamageBonus)
    }
    
    /// The type of potion.
    var potion: PotionType?
}

extension Item: CustomStringConvertible {
    
    var description: String {
        if isTreasure {
            return "\(name) worth \(value) gold pieces"
        }
        let postfix = enchantments.reduce("") { (result, enchantment) in
            guard enchantment != 0 else { return result }
            return enchantment > 0 ? "+\(enchantment)" : "\(enchantment)"
        }
        return name + postfix
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
