//
//  CombatProviding.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol CombatProviding {
    func attack(attacker: Entity, defender: Entity) -> Int?
}

/// Determines combat results based on a simplified D20 system.
///
/// - SeeAlso: https://www.d20pfsrd.com/Gamemastering/Combat/#TOC-Damage
/// - SeeAlso: http://www.easydamus.com/BasicD20.pdf
class CombatSystem: System, CombatProviding {
    
    private let d20: D20Providing
    
    init(entityManager: EntityManager, d20: D20Providing = D20()) {
        self.d20 = d20
        super.init(entityManager: entityManager)
    }
    
    // LATER: Pass in CombatComponents
    func attack(attacker: Entity, defender: Entity) -> Int? {
        guard let attackerCombatant = entityManager.combatComponent(for: attacker) else {
            return nil
        }
        guard let defenderCombatant = entityManager.combatComponent(for: defender) else {
            return nil
        }
        let attackRoll = d20.roll()
        let naturalMiss = attackRoll == 1
        let naturalHit = attackRoll == 20
        let hit = attackRoll + attackerCombatant.attackBonus >= defenderCombatant.armorClass
        if !naturalMiss && (naturalHit || hit) {
            return attackerCombatant.weaponDamage
        }
        return nil
    }
}
