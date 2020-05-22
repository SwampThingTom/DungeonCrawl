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
    let pathfinder: Pathfinding
    
    init(entityManager: EntityManager,
         gameLevel: LevelProviding,
         randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        self.gameLevel = gameLevel
        self.pathfinder = Pathfinder(map: gameLevel.map)
        super.init(entityManager: entityManager)
    }
    
    func turnAction(for enemy: EnemyComponent, with sprite: SpriteComponent) -> TurnAction {
        if let targetDirection = directionForTargetInAttackRange(from: sprite.cell) {
            return .attack(direction: targetDirection)
        }
        let chaseTarget = cellForTargetInVisibleRange(from: sprite.cell)
        enemy.enemyAIState = chaseTarget != nil ? .chase : .walk
        switch enemy.enemyAIState {
        case .chase:
            guard let chaseTarget = chaseTarget else { return .nothing }
            return chase(target: chaseTarget, sprite: sprite)
        case .wait:
            return .nothing
        case .walk:
            return followCurrentPath(enemy, sprite: sprite)
        }
    }
    
    // MARK: attack
    
    private func directionForTargetInAttackRange(from cell: GridCell) -> Direction? {
        guard let playerSprite = gameLevel.player.spriteComponent() else { return nil }
        let targetNeighbor = cell.neighbors().first { $0.cell == playerSprite.cell }
        return targetNeighbor?.direction
    }
    
    // MARK: chase
    
    private func cellForTargetInVisibleRange(from cell: GridCell) -> GridCell? {
        guard let playerSprite = gameLevel.player.spriteComponent() else { return nil }
        return cell.distance(to: playerSprite.cell) < 5 ? playerSprite.cell : nil
    }
    
    private func chase(target: GridCell, sprite: SpriteComponent) -> TurnAction {
        return move(from: sprite.cell, towards: target)
    }
    
    // MARK: walk
    
    private func followCurrentPath(_ enemy: EnemyComponent,
                                   sprite: SpriteComponent) -> TurnAction {
        if enemy.targetCell == nil || enemy.targetCell == sprite.cell {
            enemy.targetCell = findWalkTarget(sprite: sprite)
        }
        guard let targetCell = enemy.targetCell else { return .nothing }
        guard let nextCell = pathfinder.findPath(from: sprite.cell, to: targetCell).first else { return .nothing }
        guard let direction = sprite.cell.direction(to: nextCell) else { return .nothing }
        return .move(to: nextCell, direction: direction)
    }
    
    private func findWalkTarget(sprite: SpriteComponent) -> GridCell? {
        let room = gameLevel.rooms.randomElement(using: &randomNumberGenerator)
        return room?.bounds.randomCell(using: &randomNumberGenerator)
    }
    
    // MARK: move
    
    private func move(from cell: GridCell, towards targetCell: GridCell) -> TurnAction {
        guard let nextCell = pathfinder.findPath(from: cell, to: targetCell).first else { return .nothing }
        guard let direction = cell.direction(to: nextCell) else { return .nothing }
        return .move(to: nextCell, direction: direction)
    }
}
