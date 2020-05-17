//
//  CombatProviding.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol Combatant {
    
    var attackBonus: Int { get }
    var armorClass: Int { get }
    var hitPoints: Int { get set }
    var weaponDamage: Int { get }
}

protocol CombatProviding {
    func attack(attacker: Combatant, defender: Combatant) -> Int?
}

/// Determines combat results based on a simplified D20 system.
///
/// - SeeAlso: https://www.d20pfsrd.com/Gamemastering/Combat/#TOC-Damage
/// - SeeAlso: http://www.easydamus.com/BasicD20.pdf
class CombatSystem: CombatProviding {
    
    private let d20: D20Providing
    
    init(d20: D20Providing = D20()) {
        self.d20 = d20
    }
    
    func attack(attacker: Combatant, defender: Combatant) -> Int? {
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
