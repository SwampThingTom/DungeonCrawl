//
//  TurnSystem.swift
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

class TurnSystem {
    
    var gameLevel: LevelProviding
    
    init(gameLevel: LevelProviding) {
        self.gameLevel = gameLevel
    }
    
    func doTurnAction(_ action: TurnAction, for actor: Actor) -> Animation? {
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
    
    private func attack(actor: Actor, heading: Direction) -> Bool {
        guard let attacker = actor as? CombatantActor else {
            return false
        }
        guard let target = validTarget(fromCell: actor.cell, direction: heading) else {
            return false
        }
        var resultMessage: String = "\(attacker.displayName) missed \(target.displayName)"
        if let damage = attacker.attack(target) {
            target.takeDamage(damage)
            if target.isDead {
                resultMessage = "\(attacker.displayName) killed \(target.displayName)."
            } else {
                resultMessage = "\(attacker.displayName) hit \(target.displayName) for \(damage) damage."
            }
        }
        gameLevel.message?.show(resultMessage)
        return true
    }
    
    private func validTarget(fromCell cell: GridCell, direction: Direction) -> CombatantActor? {
        let targetCell = cell.neighbor(direction: direction)
        if gameLevel.player.cell == targetCell {
            return gameLevel.player as? CombatantActor
        }
        let target = gameLevel.actors.first(where: { $0.cell == targetCell })
        return target as? CombatantActor
    }
    
    // MARK: move
    
    private func move(actor: Actor, to cell: GridCell, heading: Direction) -> Bool {
        actor.cell = cell
        return true
    }
}
