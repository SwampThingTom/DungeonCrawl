//
//  EnemyTurnActionSystem.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol EnemyTurnActionProviding {
    
    /// Returns the action to be taken this turn.
    /// - Parameter actor: The actor's sprite component.
    /// - Returns: An action.
    ///
    /// - Note: Assumes that the `actor` is an enemy. If the player is within attack range, it will attack.
    func turnAction(for actor: SpriteComponent) -> TurnAction
}

class EnemyTurnActionSystem: System, EnemyTurnActionProviding {
    
    let gameLevel: LevelProviding
    
    init(entityManager: EntityManager, gameLevel: LevelProviding) {
        self.gameLevel = gameLevel
        super.init(entityManager: entityManager)
    }
    
    func turnAction(for actor: SpriteComponent) -> TurnAction {
        if let targetDirection = directionForTargetInAttackRange(from: actor.cell) {
            return .attack(direction: targetDirection)
        }
        return .nothing
    }
    
    private func directionForTargetInAttackRange(from cell: GridCell) -> Direction? {
        guard let playerSprite = gameLevel.player.spriteComponent() else { return nil }
        let targetNeighbor = cell.neighbors().first { $0.cell == playerSprite.cell }
        return targetNeighbor?.direction
    }
}
