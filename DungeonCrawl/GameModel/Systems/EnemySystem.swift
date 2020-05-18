//
//  EnemySystem.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class EnemySystem: System {
    
    let gameLevel: LevelProviding
    
    init(entityManager: EntityManager, gameLevel: LevelProviding) {
        self.gameLevel = gameLevel
        super.init(entityManager: entityManager)
    }
    
    // LATER: Pass in spriteComponent
    func turnAction(for actor: Entity) -> TurnAction {
        guard let actorSprite = entityManager.spriteComponent(for: actor) else { return .nothing }
        if let targetDirection = directionForTargetInAttackRange(from: actorSprite.cell) {
            return .attack(direction: targetDirection)
        }
        return .nothing
    }
    
    private func directionForTargetInAttackRange(from cell: GridCell) -> Direction? {
        guard let playerSprite = entityManager.spriteComponent(for: gameLevel.player) else { return nil }
        let targetNeighbor = cell.neighbors().first { $0.cell == playerSprite.cell }
        return targetNeighbor?.direction
    }
}
