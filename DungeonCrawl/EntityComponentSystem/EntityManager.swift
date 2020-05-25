//
//  EntityManager.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol EntityManaging {
    func createEntity() -> Entity
    func remove(entity: Entity)
    func add(component: Component, to entity: Entity)
    func component(of componentType: Component.Type, for entity: Entity) -> Component?
    func components(of componentType: Component.Type) -> [Component]
    func entities(with componentType: Component.Type) -> [Entity]
}

/// Associates Components with Entities.
///
/// Based on Ray Wenderlich's "Introduction to Component Based Architecture in Games".
/// https://www.raywenderlich.com/2806-introduction-to-component-based-architecture-in-games
class EntityManager: EntityManaging {
    
    private var nextUnassignedEntityId: UInt = 0
    
    private var nextEntityId: UInt {
        guard nextUnassignedEntityId < UInt.max else {
            fatalError("No more entity IDs.")
        }
        let entityId = nextUnassignedEntityId
        nextUnassignedEntityId += 1
        return entityId
    }
    
    private var components = [String: EntityComponentMap]()
    
    /// Creates a new entity.
    func createEntity() -> Entity {
        return Entity(entityId: nextEntityId, entityManager: self)
    }
    
    /// Removes an entity and all of its components.
    func remove(entity: Entity) {
        for component in components.values {
            component[entity] = nil
        }
    }
    
    /// Adds a component to an entity.
    func add(component: Component, to entity: Entity) {
        let componentsForEntity = componentMap(for: entity, of: type(of: component))
        componentsForEntity[entity] = component
        component._add(to: entity)
    }
    
    /// Returns the component of the specified type for an entity.
    func component(of componentType: Component.Type, for entity: Entity) -> Component? {
        let componentsForEntity = components[key(for: componentType)]
        return componentsForEntity?[entity]
    }
    
    /// Returns all of the components of the specified type.
    func components(of componentType: Component.Type) -> [Component] {
        guard let componentsForEntity = components[key(for: componentType)] else {
            return []
        }
        return componentsForEntity.values.map { $0 }
    }
    
    /// Returns all of the entities with the specified component type.
    func entities(with componentType: Component.Type) -> [Entity] {
        guard let componentsForEntity = components[key(for: componentType)] else {
            return []
        }
        return componentsForEntity.keys.map { $0 }
    }
    
    private func componentMap(for entity: Entity, of componentType: Component.Type) -> EntityComponentMap {
        let componentTypeKey = key(for: componentType)
        if let componentsForEntity = components[componentTypeKey] {
            return componentsForEntity
        }
        let componentsForEntity = EntityComponentMap()
        components[componentTypeKey] = componentsForEntity
        return componentsForEntity
    }
    
    private func key(for componentType: Component.Type) -> String {
        return String(describing: componentType.self)
    }
}

/// Wraps an underlying `[Entity: Component]` dictionary in a class so it can be passed by reference.
private class EntityComponentMap {
    
    private var map = [Entity: Component]()
    
    var keys: Dictionary<Entity, Component>.Keys {
        return map.keys
    }
    
    var values: Dictionary<Entity, Component>.Values {
        return map.values
    }

    subscript(key: Entity) -> Component? {
        get { map[key] }
        set { map[key] = newValue }
    }
}
