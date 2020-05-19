//
//  Component.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

/// Abstract superclass used for adding system-specific data to an entity.
class Component {
    
    private weak var owningEntity: Entity?
    
    /// The entity that owns this component.
    var entity: Entity? { return owningEntity }
    
    /// Adds the component to an Entity.
    ///
    /// - Warning: This should never be called directly. Use `Entity.add(component:)` instead.
    func _add(to entity: Entity) {
        owningEntity = entity
    }
}
