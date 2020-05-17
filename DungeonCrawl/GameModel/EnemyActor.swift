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
}
