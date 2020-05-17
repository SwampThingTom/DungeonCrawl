//
//  EnemyActor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class EnemyActor: CombatantActor, AIActor {
    
    let enemyType: EnemyType

    init(spriteName: String, model: EnemyModel) {
        enemyType = model.enemyType
        super.init(spriteName: spriteName, displayName: enemyType.description, cell: model.cell)
        armorClass = 12
        hitPoints = 5
    }
    
    func turnAction() -> TurnAction {
        if let targetDirection = directionForTargetInAttackRange() {
            return .attack(direction: targetDirection)
        }
        return .nothing
    }
    
    private func directionForTargetInAttackRange() -> Direction? {
        guard let player = gameLevel?.player as? CombatantActor else { return nil }
        let targetNeighbor = cell.neighbors().first { $0.cell == player.cell }
        return targetNeighbor?.direction
    }
}
