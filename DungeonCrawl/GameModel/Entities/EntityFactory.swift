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
        
        let combatComponent = CombatComponent(attackBonus: 0, armorClass: 10, damage: 3, maxHitPoints: 10)
        entityManager.add(component: combatComponent, to: entity)
        
        let itemsComponent = ItemsComponent()
        entityManager.add(component: itemsComponent, to: entity)
        
        let armor = createLeatherArmor()
        itemsComponent.items.append(armor)
        itemsComponent.equipped[.armor] = armor
        
        return entity
    }
    
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
    
    private func spriteComponent(for enemyType: EnemyType, cell: GridCell, uniqueID: UInt) -> SpriteComponent {
        let spriteName = "\(enemyType.description)_\(uniqueID)"
        let displayName = enemyType.description
        return SpriteComponent(spriteName: spriteName, displayName: displayName, cell: cell)
    }
    
    private func combatComponent(for enemyType: EnemyType) -> CombatComponent {
        switch enemyType {
        case .ghost:
            return CombatComponent(attackBonus: 0, armorClass: 12, damage: 3, maxHitPoints: 5)
        }
    }
}
