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
    var items = [Item]()
    private var equipped = [EquipmentSlot: Item]()
    
    func equip(item: Item) {
        guard let slot = item.equipmentSlot else { return }
        equipped[slot] = item
    }
    
    func equippedItem(for slot: EquipmentSlot?) -> Item? {
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
