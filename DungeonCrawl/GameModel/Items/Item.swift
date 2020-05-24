//
//  Item.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/22/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

enum EquipmentSlot {
    case armor
    case weapon
}

struct Item {
    var name: String
    
    /// The slot where this item can be equipped or `nil` if not equippable.
    var equipmentSlot: EquipmentSlot?
    
    var armor: ArmorModel?
    var weapon: WeaponModel?
}
