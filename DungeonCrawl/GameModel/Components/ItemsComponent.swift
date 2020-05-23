//
//  ItemsComponent.swift
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

class ItemsComponent: Component {
    
    var gold: Int = 0
    var items = [Item]()
    var equipped = [EquipmentSlot: Item]()
}

extension EntityManager {
    func itemsComponent(for entity: Entity) -> ItemsComponent? {
        return component(of: ItemsComponent.self, for: entity) as? ItemsComponent
    }
}

extension Entity {
    func itemsComponent() -> ItemsComponent? {
        return component(of: ItemsComponent.self) as? ItemsComponent
    }
}
