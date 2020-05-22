//
//  CombatComponent.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class CombatComponent: Component {
    
    var maxHitPoints: Int
    
    var attackBonus: Int
    var armorClass: Int
    var hitPoints: Int
    var weaponDamage: Int
    
    var isDead: Bool {
        return hitPoints <= 0
    }
    
    init(attackBonus: Int, armorClass: Int, maxHitPoints: Int, weaponDamage: Int) {
        self.attackBonus = attackBonus
        self.armorClass = armorClass
        self.maxHitPoints = maxHitPoints
        self.hitPoints = maxHitPoints
        self.weaponDamage = weaponDamage
    }
}

extension EntityManager {
    func combatComponent(for entity: Entity) -> CombatComponent? {
        return component(of: CombatComponent.self, for: entity) as? CombatComponent
    }
}

extension Entity {
    func combatComponent() -> CombatComponent? {
        return component(of: CombatComponent.self) as? CombatComponent
    }
}
