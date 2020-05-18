//
//  CombatProviding.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol CombatProviding {
    
    /// Calculates combat results.
    /// - Parameter attacker: The attacker's combat data.
    /// - Parameter defender: The defender's combat data.
    /// - Returns: The damage dealt by the attack, or `nil` if the attack misses.
    func attack(attacker: CombatComponent, defender: CombatComponent) -> Int?
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
    
    func attack(attacker: CombatComponent, defender: CombatComponent) -> Int? {
        let attackRoll = d20.roll()
        let naturalMiss = attackRoll == 1
        let naturalHit = attackRoll == 20
        let hit = attackRoll + attacker.attackBonus >= defender.armorClass
        if !naturalMiss && (naturalHit || hit) {
            return attacker.weaponDamage
        }
        return nil
    }
}
