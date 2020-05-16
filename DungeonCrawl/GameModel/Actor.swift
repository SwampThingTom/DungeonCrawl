//
//  Actor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol Actor: class {
    var name: String { get }
    var cell: GridCell { get set }
    var gameLevel: LevelProviding? { get set }
    func doTurnAction(_ action: TurnAction) -> Animation?
}

protocol AIActor: Actor {
    var enemyType: EnemyType { get }
    func turnAction(level: LevelProviding) -> TurnAction
}

enum TurnAction {
    case attack(direction: Direction)
    case move(to: GridCell, direction: Direction)
    case nothing
}

enum Animation: Equatable {
    case attack(heading: Direction)
    case move(to: GridCell, heading: Direction)
}

enum EnemyType {
    case ghost
}

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
        if let damage = attackerSelf.attack(target) {
            gameLevel?.message?.show("\(attackerSelf.name) hit \(target.name) for \(damage) damage.")
            target.takeDamage(damage)
        } else {
            gameLevel?.message?.show("\(attackerSelf.name) missed \(target.name)")
        }
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
