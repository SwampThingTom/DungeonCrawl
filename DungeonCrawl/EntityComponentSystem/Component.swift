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
    
    /// Removes the component from its owning entity.
    ///
    /// - Warning: This should never be called directly. Use `Entity.remove(component:)` instead.
    func _remove(from entity: Entity) {
        assert(entity == owningEntity, "remove component called for an entity that is not the owner")
        owningEntity = nil
    }
}

extension Component: Equatable {
    
    static func == (lhs: Component, rhs: Component) -> Bool {
        return type(of: lhs) == type(of: rhs) && lhs.entity == rhs.entity
    }
}
