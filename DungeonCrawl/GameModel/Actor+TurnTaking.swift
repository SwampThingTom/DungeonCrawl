//
//  Actor+TurnTaking.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

extension Actor {
    
    func doTurnAction(_ action: TurnAction) -> Animation? {
        switch action {
        case .attack(let heading):
            if attack(heading: heading) {
                return .attack(heading: heading)
            }
            
        case .move(let cell, let heading):
            if move(to: cell, heading: heading) {
                return .move(to: cell, heading: heading)
            }
            
        case .nothing:
            return nil
        }
        
        return nil
    }
    
    // MARK: attack
    
    private func attack(heading: Direction) -> Bool {
        guard let attackerSelf = self as? CombatantActor else {
            return false
        }
        guard let target = validTarget(direction: heading) else {
            return false
        }
        var resultMessage: String = "\(attackerSelf.displayName) missed \(target.displayName)"
        if let damage = attackerSelf.attack(target) {
            target.takeDamage(damage)
            if target.isDead {
                resultMessage = "\(attackerSelf.displayName) killed \(target.displayName)."
            } else {
                resultMessage = "\(attackerSelf.displayName) hit \(target.displayName) for \(damage) damage."
            }
        }
        gameLevel?.message?.show(resultMessage)
        return true
    }
    
    private func validTarget(direction: Direction) -> CombatantActor? {
        guard let gameLevel = gameLevel else {
            fatalError("The current actor has no game level")
        }
        let targetCell = cell.neighbor(direction: direction)
        if gameLevel.player.cell == targetCell {
            return gameLevel.player as? CombatantActor
        }
        let target = gameLevel.actors.first(where: { $0.cell == targetCell })
        return target as? CombatantActor
    }

    // MARK: move
    
    private func move(to cell: GridCell, heading: Direction) -> Bool {
        self.cell = cell
        return true
    }
}
