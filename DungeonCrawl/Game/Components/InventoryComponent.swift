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
    
    func add(item: ItemComponent) {
        items.append(item)
    }
    
    func remove(item: ItemComponent) {
        items = items.filter { $0 != item }
    }
    
    private var equipped = [EquipmentSlot: ItemComponent]()
    
    /// Toggles whether an item is equipped.
    func equip(itemComponent: ItemComponent) {
        assert(items.contains(itemComponent), "\(itemComponent.item) must be in inventory to be equipped")
        guard let slot = itemComponent.item.equipmentSlot else { return }
        let itemAlreadyEquipped = equipped[slot] == itemComponent
        equipped[slot] = itemAlreadyEquipped ? nil : itemComponent
    }
    
    /// The item equipped in an equipment slot.
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
