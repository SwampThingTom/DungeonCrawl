//
//  CombatComponent.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class CombatComponent: Component {
    
    var attackBonus: Int
    var armorClass: Int
    var hitPoints: Int
    var weaponDamage: Int
    
    var isDead: Bool {
        return hitPoints <= 0
    }
    
    init(attackBonus: Int, armorClass: Int, hitPoints: Int, weaponDamage: Int) {
        self.attackBonus = attackBonus
        self.armorClass = armorClass
        self.hitPoints = hitPoints
        self.weaponDamage = weaponDamage
    }
}

extension EntityManager {
    
    func combatComponent(for entity: Entity) -> CombatComponent? {
        return component(of: CombatComponent.self, for: entity) as? CombatComponent
    }
}
