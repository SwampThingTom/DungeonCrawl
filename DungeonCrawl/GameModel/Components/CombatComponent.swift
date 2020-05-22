//
//  CombatComponent.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class CombatComponent: Component {
    
    var baseAttackBonus: Int
    var baseArmorClass: Int
    var baseDamage: Int
    var maxHitPoints: Int
    
    var attackBonus: Int {
        return baseAttackBonus
    }
    
    var armorClass: Int {
        return baseArmorClass
    }
    
    var weaponDamage: Int {
        return baseDamage
    }

    var hitPoints: Int
    
    var isDead: Bool {
        return hitPoints <= 0
    }
    
    init(attackBonus: Int, armorClass: Int, damage: Int, maxHitPoints: Int) {
        self.baseAttackBonus = attackBonus
        self.baseArmorClass = armorClass
        self.baseDamage = damage
        self.maxHitPoints = maxHitPoints
        self.hitPoints = maxHitPoints
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
