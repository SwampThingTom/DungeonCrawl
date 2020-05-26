//
//  Entity.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

/// An object in the game world whose characteristics are provided by a collection of components.
class Entity {
    
    private weak var entityManager: EntityManager?
    
    /// Unique identifier for the entity.
    let entityId: UInt
    
    /// Initializes a new entity object.
    ///
    /// - Warning: This should never be called directly. Use `EntityManager.createEntity()` instead.
    init(entityId: UInt, entityManager: EntityManager) {
        self.entityId = entityId
        self.entityManager = entityManager
    }
    
    deinit {
        entityManager?.remove(entity: self)
    }
    
    /// Adds a component to the entity.
    func add(component: Component) {
        entityManager?.add(component: component, to: self)
    }
    
    /// Removes a component from the entity.
    func remove(component: Component) {
        entityManager?.remove(component: component, from: self)
    }
    
    /// Returns the entity's component of the specified type.
    func component(of componentType: Component.Type) -> Component? {
        return entityManager?.component(of: componentType, for: self)
    }
}

extension Entity: Hashable {
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.entityId == rhs.entityId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(entityId)
    }
}
