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
    /// - Returns: An animation to be rendered for the action.
    func doTurnAction(_ action: TurnAction, for actor: Entity) -> Animation?
}

class TurnTakingSystem: System, TurnTaking {
    
    var gameLevel: LevelProviding
    var combatSystem: CombatProviding
    
    init(entityManager: EntityManager, gameLevel: LevelProviding, combatSystem: CombatProviding) {
        self.gameLevel = gameLevel
        self.combatSystem = combatSystem
        super.init(entityManager: entityManager)
    }
    
    func doTurnAction(_ action: TurnAction, for actor: Entity) -> Animation? {
        switch action {
        case .attack(let heading):
            if attack(actor: actor, heading: heading) {
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
    
    private func attack(actor: Entity, heading: Direction) -> Bool {
        guard let attackerSprite = entityManager.spriteComponent(for: actor) else {
            return false
        }
        guard let attackerCombat = entityManager.combatComponent(for: actor) else {
            return false
        }
        
        guard let target = validTarget(fromCell: attackerSprite.cell, direction: heading) else {
            return false
        }
        guard let targetCombat = entityManager.combatComponent(for: target) else {
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
        guard let playerSprite = entityManager.spriteComponent(for: gameLevel.player) else {
            return nil
        }
        let targetCell = cell.neighbor(direction: direction)
        // LATER: Check all entities with a CombatComponent
        // LATER: Consider checking whether they are on the opposite "team"?
        if playerSprite.cell == targetCell {
            return gameLevel.player
        }
        let target = gameLevel.actors.first(where: { actor in
            guard let actorSprite = entityManager.spriteComponent(for: actor) else {
                return false
            }
            return actorSprite.cell == targetCell
        })
        return target
    }
    
    // MARK: move
    
    private func move(actor: Entity, to cell: GridCell, heading: Direction) -> Bool {
        guard let actorSprite = entityManager.spriteComponent(for: actor) else {
            return false
        }
        actorSprite.cell = cell
        return true
    }
    
    // MARK: show message
    
    private func showAttackMissedMessage(attacker: Entity, defender: Entity) {
        guard let attackerSprite = entityManager.spriteComponent(for: attacker),
            let defenderSprite = entityManager.spriteComponent(for: defender) else {
                return
        }
        gameLevel.message?.show("\(attackerSprite.displayName) missed \(defenderSprite.displayName)")
    }
    
    private func showAttackHitMessage(attacker: Entity, defender: Entity, damage: Int) {
        guard let attackerSprite = entityManager.spriteComponent(for: attacker),
            let defenderSprite = entityManager.spriteComponent(for: defender) else {
                return
        }
        gameLevel.message?.show("\(attackerSprite.displayName) hit \(defenderSprite.displayName) for \(damage) damage.")
    }
    
    private func showAttackKilledMessage(attacker: Entity, defender: Entity) {
        guard let attackerSprite = entityManager.spriteComponent(for: attacker),
            let defenderSprite = entityManager.spriteComponent(for: defender) else {
                return
        }
        gameLevel.message?.show("\(attackerSprite.displayName) killed \(defenderSprite.displayName).")
    }
}
