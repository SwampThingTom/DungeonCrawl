//
//  CombatantActor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class CombatantActor: Actor, Combatant {
    
    let spriteName: String
    let displayName: String
    var cell: GridCell
    var gameLevel: LevelProviding?
    
    var attackBonus: Int = 0
    var armorClass: Int = 10
    var hitPoints: Int = 10
    var weaponDamage: Int = 3
    
    var isDead: Bool {
        return hitPoints <= 0
    }
    
    init(spriteName: String, displayName: String, cell: GridCell) {
        self.spriteName = spriteName
        self.displayName = displayName
        self.cell = cell
    }
}
