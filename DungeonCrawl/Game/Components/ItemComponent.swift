//
//  ItemComponent.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/24/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class ItemComponent: Component {
    
    var item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    func enchant(armorBonus: Int) {
        item = ItemBuilder(item: item)
            .with(enchantedArmorBonus: armorBonus)
            .build()
    }
    
    func enchant(damageBonus: Int) {
        item = ItemBuilder(item: item)
            .with(enchantedDamageBonus: damageBonus)
            .build()
    }
}

extension EntityManager {
    func itemComponent(for entity: Entity) -> ItemComponent? {
        return component(of: ItemComponent.self, for: entity) as? ItemComponent
    }
}

extension Entity {
    func itemComponent() -> ItemComponent? {
        return component(of: ItemComponent.self) as? ItemComponent
    }
}
