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
        
        let itemsComponent = InventoryComponent()
        entityManager.add(component: itemsComponent, to: entity)
        
        let armor = createLeatherArmor()
        itemsComponent.items.append(armor)
        itemsComponent.equip(item: armor)
        
        let weapon = createDagger()
        itemsComponent.items.append(weapon)
        itemsComponent.equip(item: weapon)
        
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
    func createTreasure(_ treasure: Treasure) -> Entity {
        let entity = entityManager.createEntity()
        
        let spriteComponent = self.spriteComponent(for: treasure, uniqueID: entity.entityId)
        entityManager.add(component: spriteComponent, to: entity)
        
        if let gold = treasure.gold {
            let treasureComponent = TreasureComponent(gold: gold)
            entityManager.add(component: treasureComponent, to: entity)
        }
        
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
    
    private func spriteComponent(for treasure: Treasure, uniqueID: UInt) -> SpriteComponent {
        let spriteName = "gold_\(uniqueID)"
        let gold = treasure.gold ?? 0
        return SpriteComponent(spriteName: spriteName, displayName: "\(gold) gold pieces", cell: treasure.cell)
    }
}
