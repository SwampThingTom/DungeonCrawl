//
//  TurnTakingSystem.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

enum TurnAction: Equatable {
    case attack(direction: Direction)
    case move(to: GridCell, direction: Direction)
    case nothing
}

enum Animation: Equatable {
    case attack(heading: Direction)
    case death
    case move(to: GridCell, heading: Direction)
}

protocol TurnTaking {
    
    /// Applies the results of the actor's action.
    ///
    /// - Parameter action: The action to take this turn.
    /// - Parameter actor: The actor.
    /// - Parameter actorSprite: The actor's sprite component.
    /// - Returns: An animation to be rendered for the action.
    func doTurnAction(_ action: TurnAction, for actor: Entity, actorSprite: SpriteComponent) -> Animation?
}

class TurnTakingSystem: System, TurnTaking {
    
    var gameLevel: DungeonLevel
    var combatSystem: CombatProviding
    
    init(entityManager: EntityManager, gameLevel: DungeonLevel, combatSystem: CombatProviding) {
        self.gameLevel = gameLevel
        self.combatSystem = combatSystem
        super.init(entityManager: entityManager)
    }
    
    func doTurnAction(_ action: TurnAction, for actor: Entity, actorSprite: SpriteComponent) -> Animation? {
        switch action {
        case .attack(let heading):
            if attack(actor: actor, actorSprite: actorSprite, heading: heading) {
                return .attack(heading: heading)
            }
            
        case .move(let cell, let heading):
            if move(actor: actor, to: cell, heading: heading) {
                return .move(to: cell, heading: heading)
            }
            
        case .nothing:
            return nil
        }
        
        return nil
    }
    
    // MARK: attack
    
    private func attack(actor: Entity, actorSprite: SpriteComponent, heading: Direction) -> Bool {
        guard let attackerCombat = actor.combatComponent() else {
            return false
        }
        
        guard let target = validTarget(fromCell: actorSprite.cell, direction: heading) else {
            return false
        }
        guard let targetCombat = target.combatComponent() else {
            return false
        }
        
        guard let damage = combatSystem.attack(attacker: attackerCombat, defender: targetCombat) else {
            showAttackMissedMessage(attacker: actor, defender: target)
            return true
        }
        
        targetCombat.hitPoints -= damage
        if targetCombat.isDead {
            showAttackKilledMessage(attacker: actor, defender: target)
        } else {
            showAttackHitMessage(attacker: actor, defender: target, damage: damage)
        }
        
        return true
    }
    
    private func validTarget(fromCell cell: GridCell, direction: Direction) -> Entity? {
        guard let playerSprite = gameLevel.player.spriteComponent() else {
            return nil
        }
        let targetCell = cell.neighbor(direction: direction)
        // LATER: Check all entities with a CombatComponent
        // LATER: Consider checking whether they are on the opposite "team"?
        if playerSprite.cell == targetCell {
            return gameLevel.player
        }
        let target = gameLevel.actors.first(where: { actor in
            guard let actorSprite = actor.spriteComponent() else {
                return false
            }
            return actorSprite.cell == targetCell
        })
        return target
    }
    
    // MARK: move
    
    private func move(actor: Entity, to cell: GridCell, heading: Direction) -> Bool {
        guard let actorSprite = actor.spriteComponent() else { return false }
        guard !cellIsOccupied(cell) else { return false }
        actorSprite.cell = cell
        if let inventory = actor.inventoryComponent() {
            pickUpItems(at: cell, for: actor, inventory: inventory)
        }
        return true
    }
    
    private func cellIsOccupied(_ cell: GridCell) -> Bool {
        let sprites = gameLevel.entityManager.components(of: SpriteComponent.self)
        let spriteInCell = sprites.first {
            guard let sprite = $0 as? SpriteComponent else { return false }
            return sprite.occupiesCell && sprite.cell == cell
        }
        return spriteInCell != nil
    }
    
    private func pickUpItems(at cell: GridCell, for actor: Entity, inventory: InventoryComponent) {
        for component in entityManager.components(of: ItemComponent.self) {
            guard let itemComponent = component as? ItemComponent, let item = itemComponent.entity else { continue }
            guard let itemSprite = item.spriteComponent(), itemSprite.cell == cell else { continue }
            if itemComponent.item.isTreasure {
                inventory.gold += itemComponent.item.value
                entityManager.remove(entity: item)
            } else {
                inventory.items.append(itemComponent)
                item.remove(component: itemSprite)
            }
            showPickedUpTreasureMessage(actor: actor, treasureDescription: "\(itemComponent.item)")
        }
    }
    
    // MARK: show message
    
    private func showAttackMissedMessage(attacker: Entity, defender: Entity) {
        guard let attackerSprite = attacker.spriteComponent(),
            let defenderSprite = defender.spriteComponent() else {
                return
        }
        gameLevel.message?.show("\(attackerSprite.displayName) missed \(defenderSprite.displayName)")
    }
    
    private func showAttackHitMessage(attacker: Entity, defender: Entity, damage: Int) {
        guard let attackerSprite = attacker.spriteComponent(),
            let defenderSprite = defender.spriteComponent() else {
                return
        }
        gameLevel.message?.show("\(attackerSprite.displayName) hit \(defenderSprite.displayName) for \(damage) damage.")
    }
    
    private func showAttackKilledMessage(attacker: Entity, defender: Entity) {
        guard let attackerSprite = attacker.spriteComponent(),
            let defenderSprite = defender.spriteComponent() else {
                return
        }
        gameLevel.message?.show("\(attackerSprite.displayName) killed \(defenderSprite.displayName).")
    }
    
    private func showPickedUpTreasureMessage(actor: Entity, treasureDescription: String) {
        guard let actorSprite = actor.spriteComponent() else { return }
        gameLevel.message?.show("\(actorSprite.displayName) picked up \(treasureDescription)")
    }
}
