//
//  InventoryComponent.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/22/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class InventoryComponent: Component {
    
    var gold: Int = 0
    var items = [ItemComponent]()
    private var equipped = [EquipmentSlot: ItemComponent]()
    
    func equip(itemComponent: ItemComponent) {
        assert(items.contains(itemComponent), "\(itemComponent.item) must be in inventory to be equipped")
        guard let slot = itemComponent.item.equipmentSlot else { return }
        equipped[slot] = itemComponent
    }
    
    func equippedItem(for slot: EquipmentSlot?) -> ItemComponent? {
        guard let slot = slot else { return nil }
        return equipped[slot]
    }
}

extension EntityManager {
    func inventoryComponent(for entity: Entity) -> InventoryComponent? {
        return component(of: InventoryComponent.self, for: entity) as? InventoryComponent
    }
}

extension Entity {
    func inventoryComponent() -> InventoryComponent? {
        return component(of: InventoryComponent.self) as? InventoryComponent
    }
}
