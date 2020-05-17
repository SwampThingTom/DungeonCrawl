//
//  AISystem.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class AISystem {
    
    var gameLevel: LevelProviding
    
    init(gameLevel: LevelProviding) {
        self.gameLevel = gameLevel
    }
    
    func turnAction(for actor: Actor) -> TurnAction {
        if let targetDirection = directionForTargetInAttackRange(from: actor.cell) {
            return .attack(direction: targetDirection)
        }
        return .nothing
    }
    
    private func directionForTargetInAttackRange(from cell: GridCell) -> Direction? {
        guard let player = gameLevel.player as? CombatantActor else { return nil }
        let targetNeighbor = cell.neighbors().first { $0.cell == player.cell }
        return targetNeighbor?.direction
    }
}
