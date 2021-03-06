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
        
        let spriteComponent = SpriteComponent(spriteName: "player",
                                              displayName: "player",
                                              cell: cell,
                                              occupiesCell: true)
        entityManager.add(component: spriteComponent, to: entity)
        
        let combatComponent = CombatComponent(attackBonus: 0, armorClass: 10, damageDice: D3(), maxHitPoints: 10)
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
        return SpriteComponent(spriteName: spriteName, displayName: displayName, cell: cell, occupiesCell: true)
    }
    
    // Resources for monster stats:
    // https://dnd.wizards.com/products/tabletop/dm-basic-rules
    // https://www.dndbeyond.com/monsters
    // https://www.aidedd.org/dnd-filters/monsters.php
    // Balance by cutting attack bonus, damage, and hit points in half compared to D&D 5E.
    private func combatComponent(for enemyType: EnemyType) -> CombatComponent {
        switch enemyType {
        case .jellyCube:
            // CR: 1/8
            // Potentially destroys armor / weapons? See also "grey oozeling"
            let damageDice = D4()  // damage: 2.5
            return CombatComponent(attackBonus: 1, armorClass: 8, damageDice: damageDice, maxHitPoints: 5)
        case .giantBat:
            // CR: 1/4
            let damageDice = D6()  // damage: 3.5
            return CombatComponent(attackBonus: 2, armorClass: 12, damageDice: damageDice, maxHitPoints: 9)
        case .skeleton:
            // CR: 1/4
            let damageDice = D6()  // damage: 3.5
            return CombatComponent(attackBonus: 2, armorClass: 12, damageDice: damageDice, maxHitPoints: 11)
        case .shadow:
            // CR: 1/2
            let damageDice = Dice(die: D6(), modifier: 1)  // damage: 4.5
            return CombatComponent(attackBonus: 3, armorClass: 13, damageDice: damageDice, maxHitPoints: 12)
        case .giantSpider:
            // CR: 1
            let damageDice = Dice(die: D4(), numberOfDice: 2, modifier: 1)  // damage: 6
            return CombatComponent(attackBonus: 3, armorClass: 14, damageDice: damageDice, maxHitPoints: 13)
        case .ghast:
            // CR: 2
            let damageDice = Dice(die: D6(), modifier: 3)  // damage: 6.5
            return CombatComponent(attackBonus: 4, armorClass: 15, damageDice: damageDice, maxHitPoints: 20)
        }
    }
    
    private func spriteComponent(for item: ItemModel, uniqueID: UInt) -> SpriteComponent {
        let spriteName = "\(item.item.name)_\(uniqueID)"
        return SpriteComponent(spriteName: spriteName,
                               displayName: item.item.name,
                               cell: item.cell,
                               occupiesCell: false)
    }
}
