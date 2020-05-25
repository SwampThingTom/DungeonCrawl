//
//  EntityFactory.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class EntityFactory {
    
    private var entityManager: EntityManager
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }
    
    func createPlayer(cell: GridCell) -> Entity {
        let entity = entityManager.createEntity()
        
        let spriteComponent = SpriteComponent(spriteName: "player", displayName: "player", cell: cell)
        entityManager.add(component: spriteComponent, to: entity)
        
        let combatComponent = CombatComponent(attackBonus: 0, armorClass: 10, damageDie: D3(), maxHitPoints: 10)
        entityManager.add(component: combatComponent, to: entity)
        
        let inventoryComponent = InventoryComponent()
        entityManager.add(component: inventoryComponent, to: entity)
        
        let armor = ItemComponent(item: createLeatherArmor())
        inventoryComponent.items.append(armor)
        inventoryComponent.equip(itemComponent: armor)
        
        let weapon = ItemComponent(item: createDagger())
        inventoryComponent.items.append(weapon)
        inventoryComponent.equip(itemComponent: weapon)
        
        return entity
    }
    
    @discardableResult
    func createEnemy(enemyType: EnemyType, cell: GridCell) -> Entity {
        let entity = entityManager.createEntity()

        let spriteComponent = self.spriteComponent(for: enemyType, cell: cell, uniqueID: entity.entityId)
        entityManager.add(component: spriteComponent, to: entity)
        
        let enemyComponent = EnemyComponent(enemyType: enemyType)
        entityManager.add(component: enemyComponent, to: entity)
        
        let combatComponent = self.combatComponent(for: enemyType)
        entityManager.add(component: combatComponent, to: entity)
        
        return entity
    }
    
    @discardableResult
    func createItem(_ item: ItemModel) -> Entity {
        let entity = entityManager.createEntity()
        
        let spriteComponent = self.spriteComponent(for: item, uniqueID: entity.entityId)
        entityManager.add(component: spriteComponent, to: entity)
        
        let itemComponent = ItemComponent(item: item.item)
        entityManager.add(component: itemComponent, to: entity)
        
        return entity
    }
    
    private func spriteComponent(for enemyType: EnemyType, cell: GridCell, uniqueID: UInt) -> SpriteComponent {
        let spriteName = "\(enemyType)_\(uniqueID)"
        let displayName = "\(enemyType)"
        return SpriteComponent(spriteName: spriteName, displayName: displayName, cell: cell)
    }
    
    private func combatComponent(for enemyType: EnemyType) -> CombatComponent {
        switch enemyType {
        case .ghost:
            return CombatComponent(attackBonus: 0, armorClass: 12, damageDie: D3(), maxHitPoints: 5)
        }
    }
    
    private func spriteComponent(for item: ItemModel, uniqueID: UInt) -> SpriteComponent {
        let spriteName = "\(item.item.name)_\(uniqueID)"
        return SpriteComponent(spriteName: spriteName, displayName: item.item.name, cell: item.cell)
    }
}
