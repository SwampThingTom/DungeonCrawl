//
//  InventoryComponent.swift
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

class InventoryComponent: Component {
    
    var gold: Int = 0
    var items = [Item]()
    var equipped = [EquipmentSlot: Item]()
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
