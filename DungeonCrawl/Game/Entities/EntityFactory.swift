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
        
        let armorItemComponent = createItemComponent(for: createLeatherArmor())
        inventoryComponent.items.append(armorItemComponent)
        inventoryComponent.equip(itemComponent: armorItemComponent)
        
        let weaponItemComponent = createItemComponent(for: createDagger())
        inventoryComponent.items.append(weaponItemComponent)
        inventoryComponent.equip(itemComponent: weaponItemComponent)
        
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
    
    private func createItemComponent(for item: Item) -> ItemComponent {
        let entity = entityManager.createEntity()
        let itemComponent = ItemComponent(item: item)
        entityManager.add(component: itemComponent, to: entity)
        return itemComponent
    }
    
    private func spriteComponent(for enemyType: EnemyType, cell: GridCell, uniqueID: UInt) -> SpriteComponent {
        let spriteName = "\(enemyType)_\(uniqueID)"
        let displayName = "\(enemyType)"
        return SpriteComponent(spriteName: spriteName, displayName: displayName, cell: cell)
    }
    
    private func combatComponent(for enemyType: EnemyType) -> CombatComponent {
        switch enemyType {
            return CombatComponent(attackBonus: 0, armorClass: 12, damageDie: D3(), maxHitPoints: 5)
        case .ghast:
        }
    }
    
    private func spriteComponent(for item: ItemModel, uniqueID: UInt) -> SpriteComponent {
        let spriteName = "\(item.item.name)_\(uniqueID)"
        return SpriteComponent(spriteName: spriteName, displayName: item.item.name, cell: item.cell)
    }
}
