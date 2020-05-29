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

struct Item: Equatable {
    var name: String
    
    /// Indicates the item is treasure. When picked up, it adds to the player's gold.
    var isTreasure: Bool = false
    
    /// The base value of the item.
    var value: Int = 0
    
    /// The slot where this item can be equipped or `nil` if not equippable.
    var equipmentSlot: EquipmentSlot?
    
    /// The armor bonus provided when this item is equipped.
    var armorBonus: Int?
    
    var weapon: WeaponModel?
}

extension Item: CustomStringConvertible {
    
    var description: String {
        return isTreasure ? "\(name) worth \(value) gold pieces" : name
    }
}
