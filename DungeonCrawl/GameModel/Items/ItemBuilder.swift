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
    private var armorBonus: ArmorBonus?
    
    init(name: String) {
        self.name = name
    }
    
    func with(armorBonus: ArmorBonus) -> ItemBuilder {
        self.armorBonus = armorBonus
        return self
    }
    
    func build() -> Item {
        return Item(name: name, armorBonus: armorBonus)
    }
}

func createLeatherArmor() -> Item {
    return ItemBuilder(name: "Leather")
        .with(armorBonus: ArmorBonus(armorBonus: 2))
        .build()
}
