//
//  CombatantActor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class CombatantActor: Actor, Combatant {
    
    var name: String
    var cell: GridCell
    var gameLevel: LevelProviding?
    var combat: CombatProviding = Combat(d20: D20())
    
    var attackBonus: Int = 1
    var armorClass: Int = 1
    var hitPoints: Int = 10
    
    init(name: String, cell: GridCell) {
        self.name = name
        self.cell = cell
    }
    
    func damage() -> Int {
        return 1
    }
    
    func takeDamage(_ damage: Int) {
        hitPoints -= damage
    }

    func attack(_ target: Combatant) -> Int? {
        return combat.attack(attacker: self, defender: target)
    }
}
