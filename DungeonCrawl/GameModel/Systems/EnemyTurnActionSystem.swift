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
    /// - Parameter enemy: The entity's enemy component.
    /// - Parameter sprite: The entity's sprite component.
    /// - Returns: An action.
    func turnAction(for enemy: EnemyComponent, with sprite: SpriteComponent) -> TurnAction
}

class EnemyTurnActionSystem: System, EnemyTurnActionProviding {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    let gameLevel: LevelProviding

    init(entityManager: EntityManager,
         gameLevel: LevelProviding,
         randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        self.gameLevel = gameLevel
        super.init(entityManager: entityManager)
    }
    
    func turnAction(for enemy: EnemyComponent, with sprite: SpriteComponent) -> TurnAction {
        if let targetDirection = directionForTargetInAttackRange(from: sprite.cell) {
            return .attack(direction: targetDirection)
        }
        switch enemy.enemyAIState {
        case .chase:
            break
        case .hunt:
            break
        case .walk:
            return followCurrentPath(enemy, sprite: sprite)
        }
        return .nothing
    }
    
    private func directionForTargetInAttackRange(from cell: GridCell) -> Direction? {
        guard let playerSprite = gameLevel.player.spriteComponent() else { return nil }
        let targetNeighbor = cell.neighbors().first { $0.cell == playerSprite.cell }
        return targetNeighbor?.direction
    }
    
    private func followCurrentPath(_ enemy: EnemyComponent,
                                   sprite: SpriteComponent) -> TurnAction {
        if enemy.targetCell == nil || enemy.targetCell == sprite.cell {
            enemy.targetCell = findWalkTarget(sprite: sprite)
        }
        guard
            let targetCell = enemy.targetCell,
            let direction = sprite.cell.direction(to: targetCell)
        else {
            return .nothing
        }
        return .move(to: targetCell, direction: direction)
    }
    
    private func findWalkTarget(sprite: SpriteComponent) -> GridCell {
        let neighborCells = sprite.cell.neighbors().filter { neighbor in
            guard let tile = gameLevel.map.tile(at: neighbor.cell) else { return false }
            return !tile.isObstacle
        }
        return neighborCells.randomElement(using: &randomNumberGenerator)!.cell
    }
}
